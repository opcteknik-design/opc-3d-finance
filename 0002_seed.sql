INSERT OR IGNORE INTO settings(key, value) VALUES
('company_name', 'OPC 3D'),
('starting_capital_usd', '100000'),
('building_monthly_rent_try', '390000'),
('building_floor_count', '6'),
('showroom_floor_count', '1'),
('showroom_monthly_rent_share_try', '65000'),
('department_manager_salary_try', '80000'),
('shared_employee_salary_try', '85000'),
('shared_employee_sgk_try', '30000'),
('department_vehicle_value_try', '700000');

INSERT OR IGNORE INTO suppliers(name, currency) VALUES ('Genix', 'USD');

INSERT OR IGNORE INTO stock_locations(code, name) VALUES
('ANA_DEPO', 'Ana Depo'),
('SHOWROOM', 'Showroom'),
('ARIZALI', 'Arızalı Stok'),
('YOLDA', 'Yoldaki Ürün'),
('DEMO', 'Demo'),
('MUSTERI_AYRILMIS', 'Müşteriye Ayrılmış');

INSERT OR IGNORE INTO weekly_metrics(
  week_date, sales, collections, payments, stock_value, currency, faulty_units, source_file
) VALUES ('2026-08-03', 61037, 41914, 49150, 64557, 'USD', 6, '3d haftalık rap38.xlsx');

INSERT OR IGNORE INTO supplier_transactions(
  supplier_id, transaction_date, document_no, transaction_type, description,
  debit, credit, currency, source_file, source_hash
)
SELECT id, '2026-08-03', 'OPENING', 'Bakiye', 'Genix başlangıç cari bakiyesi',
       250956.07, 0, 'USD', 'genıx 0308 ekstre.xlsx', 'seed-genix-opening'
FROM suppliers WHERE name='Genix';
