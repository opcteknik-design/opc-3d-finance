# OPC 3D Finance v0.1

Cloudflare Workers + D1 üzerinde çalışan ilk OPC 3D yönetim uygulaması.

## İçerik

- Dashboard
- Haftalık satış, tahsilat, ödeme ve stok
- Genix cari bakiyesi
- Arızalı cihaz adedi
- Excel/XLS/CSV önizleme
- D1 veri tabanı

## Kurulum

```bash
npm install
npx wrangler login
npx wrangler d1 create opc-3d-db
```

Oluşan `database_id` değerini `wrangler.jsonc` dosyasına yazın.

```bash
npm run db:migrate:remote
npm run db:seed:remote
npm run deploy
```

## İlk kayıtlı değerler

- Başlangıç sermayesi: 100.000 USD
- Genix cari bakiyesi: 250.956,07 USD
- Haftalık satış: 61.037 USD
- Haftalık tahsilat: 41.914 USD
- Haftalık ödeme: 49.150 USD
- Stok değeri: 64.557 USD
- Arızalı cihaz: 6 adet
- Showroom kira payı: 65.000 TL
