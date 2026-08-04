PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS suppliers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  currency TEXT NOT NULL DEFAULT 'USD',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  sku TEXT UNIQUE,
  name TEXT NOT NULL,
  brand TEXT,
  category TEXT,
  active INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS stock_locations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  code TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS weekly_metrics (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  week_date TEXT NOT NULL UNIQUE,
  sales REAL NOT NULL DEFAULT 0,
  collections REAL NOT NULL DEFAULT 0,
  payments REAL NOT NULL DEFAULT 0,
  stock_value REAL NOT NULL DEFAULT 0,
  currency TEXT NOT NULL DEFAULT 'USD',
  faulty_units INTEGER NOT NULL DEFAULT 0,
  source_file TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS supplier_transactions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  supplier_id INTEGER NOT NULL,
  transaction_date TEXT NOT NULL,
  document_no TEXT,
  transaction_type TEXT NOT NULL,
  description TEXT,
  debit REAL NOT NULL DEFAULT 0,
  credit REAL NOT NULL DEFAULT 0,
  currency TEXT NOT NULL DEFAULT 'USD',
  source_file TEXT,
  source_hash TEXT UNIQUE,
  FOREIGN KEY(supplier_id) REFERENCES suppliers(id)
);

CREATE TABLE IF NOT EXISTS sales_orders (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  order_no TEXT NOT NULL UNIQUE,
  order_date TEXT NOT NULL,
  channel TEXT,
  customer_name TEXT,
  net_amount REAL NOT NULL DEFAULT 0,
  currency TEXT NOT NULL DEFAULT 'TRY',
  invoice_no TEXT,
  cargo_company TEXT,
  cargo_tracking_no TEXT,
  status TEXT NOT NULL DEFAULT 'Sipariş Alındı',
  source_file TEXT
);

CREATE TABLE IF NOT EXISTS faulty_devices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  serial_no TEXT UNIQUE,
  model TEXT,
  fault_date TEXT,
  fault_type TEXT,
  status TEXT NOT NULL DEFAULT 'Bekliyor',
  location TEXT NOT NULL DEFAULT 'Arızalı Stok',
  supplier_case_no TEXT,
  unit_cost REAL NOT NULL DEFAULT 0,
  currency TEXT NOT NULL DEFAULT 'USD',
  notes TEXT
);

CREATE TABLE IF NOT EXISTS import_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  import_type TEXT NOT NULL,
  file_name TEXT NOT NULL,
  file_hash TEXT NOT NULL UNIQUE,
  row_count INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL,
  message TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
