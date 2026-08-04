import { Hono } from 'hono';
import * as XLSX from 'xlsx';

type Bindings = { DB: D1Database; ASSETS: Fetcher };
const app = new Hono<{ Bindings: Bindings }>();

app.get('/api/health', (c) => c.json({ ok: true, app: 'OPC 3D', version: '0.1.0' }));

app.get('/api/dashboard', async (c) => {
  const settingsRows = await c.env.DB.prepare('SELECT key, value FROM settings').all();
  const settings = Object.fromEntries((settingsRows.results ?? []).map((r: any) => [r.key, r.value]));

  const weekly = await c.env.DB.prepare(
    'SELECT * FROM weekly_metrics ORDER BY week_date DESC LIMIT 1'
  ).first<any>();

  const genix = await c.env.DB.prepare(`
    SELECT COALESCE(SUM(st.debit),0) - COALESCE(SUM(st.credit),0) AS balance
    FROM supplier_transactions st
    JOIN suppliers s ON s.id = st.supplier_id
    WHERE s.name = 'Genix'
  `).first<any>();

  return c.json({
    company: settings.company_name ?? 'OPC 3D',
    startingCapitalUsd: Number(settings.starting_capital_usd ?? 0),
    showroomRentShareTry: Number(settings.showroom_monthly_rent_share_try ?? 0),
    managerSalaryTry: Number(settings.department_manager_salary_try ?? 0),
    weekly: weekly ?? null,
    genixBalanceUsd: Number(genix?.balance ?? 0),
    faultyUnits: Number(weekly?.faulty_units ?? 0)
  });
});

app.get('/api/weekly', async (c) => {
  const rows = await c.env.DB.prepare(
    'SELECT * FROM weekly_metrics ORDER BY week_date DESC LIMIT 52'
  ).all();
  return c.json(rows.results ?? []);
});

app.post('/api/import/preview', async (c) => {
  const form = await c.req.formData();
  const file = form.get('file');
  const importType = String(form.get('type') ?? '');

  if (!(file instanceof File)) return c.json({ error: 'Dosya bulunamadı.' }, 400);
  if (!['stock', 'sales', 'genix'].includes(importType)) {
    return c.json({ error: 'Geçersiz içe aktarma türü.' }, 400);
  }

  const buffer = await file.arrayBuffer();
  const workbook = XLSX.read(buffer, { type: 'array', cellDates: true });
  const sheets = workbook.SheetNames.map((name) => {
    const rows = XLSX.utils.sheet_to_json(workbook.Sheets[name], {
      header: 1, defval: null, raw: false
    }) as unknown[][];
    return { name, rowCount: rows.length, preview: rows.slice(0, 12) };
  });

  return c.json({ fileName: file.name, importType, sheetCount: sheets.length, sheets });
});

app.all('*', async (c) => c.env.ASSETS.fetch(c.req.raw));
export default app;
