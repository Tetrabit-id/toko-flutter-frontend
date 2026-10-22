# Skema Paket: Subscription vs Offline

Dokumen ini menjelaskan rancangan dua paket (Subscription & Offline) untuk aplikasi
Toko POS (Flutter, GetX) beserta tutorial perubahan backend Golang.

---

## 1. Kondisi project saat ini (hasil analisa)

| Area | Kondisi sekarang |
|---|---|
| State & DI | GetX. Semua controller di-`Get.put` di [app_binding.dart](../lib/routes/app_binding.dart) dan diakses global lewat [state_global.dart](../lib/routes/state_global.dart). |
| Storage lokal | Hanya `GetStorage` (key-value) untuk sesi: `token`, `_id`, `cabangId`, `role`, `parent`, `parentId`, `store`, `owner`. Tidak ada database lokal. |
| API | Semua fitur langsung `http` ke `$baseUrl` ([base_url.dart](../lib/routes/base_url.dart)). Tidak ada lapisan repository, jadi **tanpa internet aplikasi tidak bisa apa-apa**. |
| Auth | Login owner (email/Google) & karyawan. `autoLogin()` di [auth_controllers.dart](../lib/controllers/auth_controllers.dart) **selalu memanggil API** (`checkApiToken`) — kalau gagal, user dilempar ke login. Ini harus diubah untuk mode offline. |
| Aktivasi | Field `statusPembayaran` di user. `false` → halaman info pembayaran → transfer BCA → konfirmasi WA ([payment_detail.dart](../lib/modules/InfoPembayaranPage/mobile_ui/payment_detail.dart)). |
| Role | `admin` (owner) → 5 tab, `Kasir` → kasir+stok, `Gudang` → stok+laporan. |
| Kasir | [kasir_controllers.dart](../lib/controllers/kasir_controllers.dart): `bayar()` POST pesanan (server yang membuat `noInvoice`), lalu `transaksi()` POST transaksi terpisah. 2 request, tidak atomik. |
| Multi cabang | `cabang`, `stok-cabang`, `pengiriman` (kirim stok), `obrolan` (chat via WebSocket `$baseUrlWS`). |
| Payment gateway | [xendit_controller.dart](../lib/controllers/xendit_controller.dart) — **secret key Xendit di-hardcode di aplikasi**. Lihat bagian Keamanan. |

---

## 2. Perbandingan paket

| Fitur | Subscription | Offline |
|---|:-:|:-:|
| Register & login (butuh internet) | ✓ | ✓ (hanya saat register, aktivasi, ganti HP) |
| Multi cabang | ✓ | ✗ (hanya **Pusat**) |
| Kirim stok ke cabang | ✓ | ✗ |
| Chat antar cabang | ✓ | ✗ |
| Kelola & login karyawan | ✓ | ✗ (hanya owner) |
| Kasir | ✓ online + **offline-first** | ✓ full lokal |
| Transaksi online (Midtrans: QRIS/VA/e-wallet) | ✓ | ✗ (tunai saja) |
| Kelola stok | ✓ semua cabang | ✓ pusat |
| Pelanggan / member + poin | ✓ | ✓ lokal |
| Kasbon | ✓ | ✓ lokal |
| Rekap kas (kas awal/akhir) | ✓ per karyawan | ✓ lokal (atas nama owner) |
| Laporan (transaksi, kasbon) | ✓ dari server | ✓ dihitung dari DB lokal |
| Lokasi data | Cloud (lokal hanya cache + antrean) | HP user |
| Aktivasi | Admin set `statusPembayaran = true` | User input **kode aktivasi** |

---

## 3. Alur register & aktivasi

```
                 ┌────────────────────┐
  Register  ───▶ │ Pilih Paket (card) │
  (online)       └─────────┬──────────┘
            ┌──────────────┴───────────────┐
     Subscription                       Offline
            │                              │
   POST /register {plan:"subscription"}   POST /register {plan:"offline"}
            │                              │
   Halaman info bayar ──▶ WA admin    Halaman info bayar ──▶ WA admin
            │                              │
   Admin set statusPembayaran=true    Admin generate KODE di BE, kirim via WA
            │                              │
   Login ─▶ langsung masuk           Login ─▶ Halaman "Masukkan Kode Aktivasi"
                                           │  POST /license/activate {code, deviceId}
                                           ▼
                                   Server balas LISENSI bertanda tangan (Ed25519)
                                           │  disimpan di HP
                                           ▼
                                   Mode offline aktif, tidak butuh internet lagi
```

### Kenapa lisensi ditandatangani (bukan sekadar flag `true` di storage)?
Kalau aktivasi offline hanya disimpan sebagai `isActivated = true` di GetStorage, siapa pun
bisa mengedit file storage (HP root/emulator) dan memakai aplikasi gratis. Dengan lisensi
yang **ditandatangani private key di server** dan diverifikasi **public key yang ditanam di
aplikasi**, lisensi tidak bisa dipalsukan, dan pengecekannya tetap bisa 100% offline.

Isi lisensi:
```json
{
  "licenseId": "lic_6731...",
  "userId": "65f0...",
  "plan": "offline",
  "deviceId": "a1b2c3d4e5f6",
  "store": "Toko Makmur",
  "issuedAt": "2026-10-22T10:00:00Z"
}
```
Aplikasi menolak lisensi jika signature tidak valid **atau** `deviceId` ≠ ID HP saat ini
(lisensi yang disalin ke HP lain otomatis tidak berlaku).

### Ganti HP (paket offline)
1. User install di HP baru → login (online) dengan akunnya.
2. Server tahu `plan = offline`, aplikasi tidak punya lisensi untuk device ini → halaman kode aktivasi.
3. User minta kode baru ke admin via WA → admin generate kode → user input.
4. Server **mencabut (revoke) lisensi HP lama** dan menerbitkan lisensi baru untuk HP baru.

Catatan penting:
- **Data offline tidak ikut pindah**, karena data hanya ada di HP lama. Disarankan
  menambahkan fitur **Backup/Restore** (export DB lokal ke file `.json`/`.db`, share ke
  WA/Drive, import di HP baru). Lihat Fase 5.
- HP lama yang tidak pernah online akan tetap jalan (tidak ada cara mencabutnya tanpa
  internet). Mitigasi: setiap kali HP offline kebetulan online, aplikasi memanggil
  `GET /license/status`; jika `revoked`, lisensi lokal dihapus.

---

## 4. Arsitektur Flutter

### 4.1 Package tambahan
```yaml
dependencies:
  sqflite: ^2.3.3          # DB lokal (transaksi, stok, produk)
  path: ^1.9.0
  connectivity_plus: ^6.0.5 # deteksi online/offline
  device_info_plus: ^10.1.2 # device id (iOS identifierForVendor)
  android_id: ^0.4.0        # ANDROID_ID stabil per device+app signing key
  cryptography: ^2.7.0      # verifikasi signature Ed25519
  uuid: ^4.4.2              # clientId transaksi offline (idempotency)
  webview_flutter: ^4.8.0   # (opsional) tampilkan halaman Snap Midtrans in-app
```
> `GetStorage` tetap dipakai untuk sesi & lisensi. Transaksi **jangan** di GetStorage
> (seluruh isi file dimuat ke memori dan ditulis ulang tiap perubahan → lambat & rawan korup).

### 4.2 Struktur folder baru
```
lib/
  models/
    plan.dart                 # enum AppPlan { subscription, offline }
    license.dart
  services/
    plan_service.dart         # sumber kebenaran: paket aktif + feature flag
    license_service.dart      # simpan, verifikasi, revoke lisensi
    device_id_service.dart
    local_db.dart             # sqflite: schema & migrasi
    connectivity_service.dart
    sync_service.dart         # kirim outbox ke cloud (khusus subscription)
    midtrans_service.dart     # panggil BE untuk Snap token
  repositories/
    transaksi_repository.dart # abstract + RemoteTransaksiRepo + LocalTransaksiRepo
    stok_repository.dart
    laporan_repository.dart
  modules/
    Register/mobile_ui/choose_plan.dart
    Aktivasi/mobile_ui/aktivasi_kode.dart
```

### 4.3 Feature gating (satu tempat)
```dart
// lib/services/plan_service.dart
enum AppPlan { subscription, offline }

class PlanService extends GetxController {
  AppPlan get plan =>
      token.read('plan') == 'offline' ? AppPlan.offline : AppPlan.subscription;

  bool get isOffline => plan == AppPlan.offline;
  bool get canMultiCabang => !isOffline;
  bool get canKirimStok => !isOffline;
  bool get canChat => !isOffline;
  bool get canKelolaKaryawan => !isOffline;
  bool get canPaymentGateway => !isOffline;
}
```
Dipakai di:
- [navbar.dart](../lib/routes/navbar.dart) & [index_screens.dart](../lib/routes/index_screens.dart): offline → tab **Pengguna** disembunyikan (Beranda, Stok, Kasir, Laporan).
- Halaman stok: tombol tambah cabang & kirim stok ([send_stok_popup.dart](../lib/components/send_stok_popup.dart)) disembunyikan.
- Home/dropdown: menu Obrolan disembunyikan.
- [body_pembayaran.dart](../lib/modules/Kasir/mobile_ui/components/body_pembayaran.dart): tombol "Bayar Online" hanya jika `canPaymentGateway`.
- Route guard (`GetMiddleware`) untuk route `obrolan`, `addCabang`, `addUser`, `user` → redirect jika fitur tidak tersedia.

### 4.4 Alur startup (`autoLogin` baru)
```
start
 ├─ ada lisensi offline yang valid (signature OK + deviceId cocok)?
 │     └─ ya → token.write('plan','offline') → IndexPage   (TANPA panggil API)
 │            └─ background: jika online, cek GET /license/status (revoke?)
 ├─ tidak ada token → WelcomePage
 └─ ada token → checkApiToken (online)
       ├─ plan == offline → belum ada lisensi → AktivasiKodePage
       ├─ plan == subscription && !statusPembayaran → PaymentInfoForOwner (WA)
       └─ subscription aktif → IndexPage / IndexKasir / IndexGudang (seperti sekarang)
```
Untuk subscription yang sedang tidak ada internet: jika `token` ada dan request gagal
karena jaringan (bukan 401), **jangan** lempar ke login — masuk pakai data sesi
terakhir di GetStorage, lalu kasir berjalan offline-first (4.6).

### 4.5 Database lokal (sqflite)
> **Sudah diimplementasikan (Fase 2)** di [local_db.dart](../lib/services/local_db.dart) dan
> [lib/repositories/](../lib/repositories/). Bedanya dengan rancangan di bawah: nama tabel &
> kolom **mengikuti nama field JSON API** (`_id`, `noInvoice`, `jumlahTransaksi`,
> `memberships`, `pesanan`, ...), sehingga hasil query langsung dipakai UI yang sama.
> Setiap controller API punya cabang `if (paket.isOffline)` yang membaca/menulis DB lokal.
> Kolom `_id` (UUID dari HP) berfungsi sebagai `client_id` untuk sync di Fase 3.
> Satu file DB per akun: `toko_offline_{userId}.db`.

Rancangan awal:
```sql
CREATE TABLE produk (
  id TEXT PRIMARY KEY, kode TEXT UNIQUE, nama TEXT, kategori_id TEXT, merk_id TEXT,
  satuan TEXT, harga INTEGER, harga_beli INTEGER, foto TEXT, updated_at TEXT
);
CREATE TABLE stok (
  id TEXT PRIMARY KEY, produk_id TEXT, cabang_id TEXT, qty INTEGER, updated_at TEXT
);
CREATE TABLE kategori (id TEXT PRIMARY KEY, kode TEXT, nama TEXT);
CREATE TABLE merk     (id TEXT PRIMARY KEY, kode TEXT, nama TEXT);

CREATE TABLE transaksi (
  client_id TEXT PRIMARY KEY,         -- UUID v4, jadi idempotency key saat sync
  no_invoice TEXT UNIQUE, cabang_id TEXT, user_id TEXT, nama_kasir TEXT,
  tanggal TEXT, discount_name TEXT, discount_unit TEXT, discount_amount INTEGER,
  sub_total INTEGER, total INTEGER, bayar INTEGER, kembalian INTEGER,
  metode TEXT DEFAULT 'cash',
  sync_status TEXT DEFAULT 'pending'  -- pending | synced (khusus subscription)
);
CREATE TABLE transaksi_item (
  id INTEGER PRIMARY KEY AUTOINCREMENT, transaksi_client_id TEXT,
  stok_id TEXT, produk_id TEXT, kode TEXT, nama TEXT,
  harga INTEGER, qty INTEGER, total INTEGER
);

-- Sama dengan field POST /memberships sekarang
CREATE TABLE pelanggan (
  id TEXT PRIMARY KEY,                -- UUID lokal
  member_id TEXT UNIQUE, cabang_id TEXT, nik TEXT, nama TEXT, email TEXT,
  phone TEXT, alamat TEXT, poin INTEGER DEFAULT 0, created_at TEXT
);

-- Sama dengan field POST /kasbon sekarang
CREATE TABLE kasbon (
  id TEXT PRIMARY KEY,
  pelanggan_id TEXT REFERENCES pelanggan(id),
  transaksi_client_id TEXT REFERENCES transaksi(client_id),
  cabang_id TEXT, note TEXT, tanggal TEXT,
  status TEXT DEFAULT 'Belum dibayar', -- Belum dibayar | Lunas
  tanggal_lunas TEXT
);

-- Sama dengan field POST /rekap-kas sekarang
CREATE TABLE rekap_kas (
  id TEXT PRIMARY KEY,
  karyawan_id TEXT,                   -- offline: selalu id owner
  cabang_id TEXT, tanggal TEXT,
  kas_awal INTEGER, kas_akhir INTEGER DEFAULT 0
);
```
- **Offline**: semua tabel adalah data utama. Laporan = query `SUM/GROUP BY` di
  `transaksi`; laporan kasbon = `kasbon JOIN pelanggan JOIN transaksi`.
- **Subscription**: `produk/stok/kategori/merk` = cache (di-refresh saat online);
  `transaksi` = **outbox** (antrean kirim).

#### Catatan pelanggan, kasbon & rekap kas di mode offline
- **Checkout dengan member/kasbon dalam 1 DB transaction**: simpan `transaksi` +
  `transaksi_item` → kurangi `stok` → jika kasbon aktif, insert `kasbon` yang langsung
  menunjuk `transaksi_client_id` → tambah `poin` pelanggan (+100, sama seperti sekarang).
  Sekarang di [kasir_controllers.dart](../lib/controllers/kasir_controllers.dart) kasbon
  mengambil `transaksiId` dari `getApiTransaksi.getApi()` lalu `data.last['_id']` — itu
  rawan salah transaksi kalau ada 2 kasir bersamaan, dan tidak bisa offline. Dengan
  `client_id` dibuat di HP, masalah ini hilang.
- **Member ID** dibuat di HP (mis. `MBR-{4 char deviceId}-{seq}`), karena tidak ada server
  yang membagikan nomor.
- **Kartu NFC member** ([nfc_controller.dart](../lib/controllers/nfc_controller.dart))
  tetap jalan: hasil baca kartu dicocokkan ke `pelanggan.member_id` lokal.
- **Rekap kas** di offline hanya punya satu pengguna (owner), jadi `karyawan_id` = id owner.
  Kas akhir yang diharapkan = `kas_awal + SUM(transaksi tunai hari itu)` — bisa dihitung
  lokal untuk membantu owner mencocokkan uang di laci.
- **Subscription saat tidak ada internet**: pelanggan & kasbon baru ikut masuk outbox
  (lihat 4.6) supaya kasir tetap bisa memilih member/kasbon saat sinyal hilang.

### 4.6 Offline-first untuk Subscription (kirim ke cloud lalu hapus lokal)
> **Sudah diimplementasikan (Fase 3)**: [connectivity_service.dart](../lib/services/connectivity_service.dart),
> [sync_service.dart](../lib/services/sync_service.dart), [local_sync_repository.dart](../lib/repositories/local_sync_repository.dart),
> banner status di atas navbar ([sync_banner.dart](../lib/components/sync_banner.dart)).
> - Saat online, aplikasi tetap memakai API seperti biasa, dan menyimpan stok, pelanggan, transaksi,
>   kasbon, rekap kas & cabang terakhir sebagai cache.
> - Saat server tidak terjangkau (dicek ketika kasir menekan Bayar), transaksi + kasbon + poin,
>   pelanggan baru, dan rekap kas baru masuk antrean (`pending = 1`).
> - Kelola stok, cabang, kirim stok, edit akun tetap wajib online (muncul pesan "butuh internet").
> - App dibuka tanpa internet: masuk dengan sesi terakhir.
> - Nomor invoice & member ID berbasis waktu (bukan urutan), karena data yang sudah terkirim dihapus dari HP.

Rancangan awal:
```
Kasir bayar ──▶ simpan ke tabel transaksi (sync_status=pending)
            ──▶ kurangi qty di cache stok lokal
            ──▶ SyncService.trigger()

SyncService (jalan saat: app start, koneksi kembali, setiap 1 menit jika ada pending)
  1. ambil transaksi pending (batch maks 50) + item
  2. POST /sync/transaksi  { transaksi: [...] }
  3. server balas { accepted: [clientId...], rejected: [{clientId, reason}] }
  4. DELETE dari lokal semua clientId yang accepted  ← "hapus storage lokal"
  5. refresh cache stok dari server
```
Aturan penting:
- **Nomor invoice dibuat di HP** (sekarang dibuat server di endpoint pesanan — harus
  diubah). Format usulan: `INV-{yyMMdd}-{4 char deviceId}-{seq}` → unik walau offline
  di banyak HP/cabang.
- `client_id` UUID → server membuat **unique index**, jadi kalau request terkirim dua kali
  (sinyal putus setelah server simpan), tidak ada transaksi ganda.
- Hapus lokal **hanya setelah ACK server**, bukan sebelum.
- Master data (produk/stok) tetap di-cache, tidak dihapus — dibutuhkan agar kasir bisa
  jalan saat offline berikutnya.
- Konflik stok (2 cabang jual barang yang sama saat offline): server adalah sumber
  kebenaran, stok boleh minus & ditandai (konsep `qty < 0` sudah ada di `getOutStok`).
- Transaksi Midtrans **wajib online** (tidak masuk outbox).
- Pelanggan baru, kasbon, dan rekap kas yang dibuat saat offline ikut di-sync. Urutan kirim:
  **pelanggan → transaksi → kasbon → rekap kas** (kasbon butuh pelanggan & transaksi
  sudah ada di server). Payload `/sync/transaksi` cukup diperluas jadi
  `{pelanggan:[], transaksi:[], kasbon:[], rekapKas:[]}`, masing-masing dengan `clientId`.

### 4.7 Pola repository (agar controller tidak peduli online/offline)
```dart
abstract class TransaksiRepository {
  Future<void> simpan(TransaksiLokal trx);       // header + item sekaligus
  Future<List<Map>> list({DateTime? dari, DateTime? sampai});
}

class LocalTransaksiRepository implements TransaksiRepository { /* sqflite */ }
class RemoteTransaksiRepository implements TransaksiRepository { /* http */ }

// Binding:
Get.put<TransaksiRepository>(
  plan.isOffline ? LocalTransaksiRepository() : OutboxTransaksiRepository(),
);
```
`AddKasir.bayar()` + `transaksi()` digabung jadi satu `checkout()` yang memanggil
`TransaksiRepository.simpan()`. Ini juga memperbaiki masalah 2 request tidak atomik.

### 4.8 Midtrans di kasir (subscription)
> **Sudah diimplementasikan (Fase 4)**: [midtrans_service.dart](../lib/services/midtrans_service.dart),
> [midtrans_wait_popup.dart](../lib/components/midtrans_wait_popup.dart), `AddKasir.bayarOnline()`.
> Tombol "Non Tunai" → `POST /payments/midtrans/snap` (kirim `stokId` + `qty`, harga dihitung server)
> → buka halaman Snap → cek `GET /payments/midtrans/{orderId}/status` tiap 3 detik → setelah `paid`
> transaksi langsung dicatat lewat antrean sync dengan `metode: "midtrans"` (server menolak jika
> pembayaran noInvoice itu belum lunas). Xendit sudah dihapus.

Rancangan awal:
```
Kasir pilih "Bayar Online"
  └─ POST /payments/midtrans/snap {noInvoice, amount, items}   (BE, pakai Server Key)
       └─ balas {snapToken, redirectUrl}
  └─ buka redirectUrl (webview_flutter / url_launcher inAppBrowserView)
  └─ pelanggan bayar QRIS / VA / e-wallet
  └─ Midtrans ──webhook──▶ BE /payments/midtrans/notification ──▶ status transaksi = paid
  └─ App cek status: polling GET /payments/midtrans/{noInvoice}/status tiap 3 detik
     (atau kirim event lewat WebSocket yang sudah ada) → jika paid: cetak struk, selesai.
```
**Server Key Midtrans tidak boleh ada di aplikasi.** Aplikasi hanya tahu `snapToken`/`redirectUrl`.

---

## 5. Tutorial Backend (Golang)

Contoh memakai **Gin + MongoDB driver** (respons API sekarang memakai `_id`, jadi
diasumsikan Mongo). Sesuaikan dengan framework yang Anda pakai — logikanya sama.

### 5.1 Perubahan koleksi `users`
```go
type User struct {
    ID                primitive.ObjectID `bson:"_id,omitempty" json:"_id"`
    // ... field lama ...
    Plan              string     `bson:"plan" json:"plan"`                           // "subscription" | "offline"
    StatusPembayaran  bool       `bson:"statusPembayaran" json:"statusPembayaran"`   // dipakai subscription
    SubscriptionUntil *time.Time `bson:"subscriptionUntil,omitempty" json:"subscriptionUntil,omitempty"`
}
```
- `POST /register/phone` & `/register/google`: terima field `plan`, validasi hanya
  `subscription|offline`, default `subscription` untuk user lama.
- Respons login & `GET /users/:id` sertakan `plan`.
- Migrasi user lama: `db.users.updateMany({plan:{$exists:false}}, {$set:{plan:"subscription"}})`.

### 5.2 Koleksi baru
```go
type ActivationCode struct {
    ID        primitive.ObjectID  `bson:"_id,omitempty"`
    Code      string              `bson:"code"`             // unique index
    UserID    primitive.ObjectID  `bson:"userId"`           // kode terikat ke 1 akun
    Status    string              `bson:"status"`           // unused | used | revoked
    UsedAt    *time.Time          `bson:"usedAt,omitempty"`
    DeviceID  string              `bson:"deviceId,omitempty"`
    CreatedBy string              `bson:"createdBy"`
    CreatedAt time.Time           `bson:"createdAt"`
    ExpiresAt time.Time           `bson:"expiresAt"`        // mis. 7 hari setelah dibuat
}

type License struct {
    ID         primitive.ObjectID `bson:"_id,omitempty"`
    UserID     primitive.ObjectID `bson:"userId"`
    DeviceID   string             `bson:"deviceId"`
    DeviceName string             `bson:"deviceName"`
    Status     string             `bson:"status"`            // active | revoked
    IssuedAt   time.Time          `bson:"issuedAt"`
    RevokedAt  *time.Time         `bson:"revokedAt,omitempty"`
}
```
Index:
```js
db.activation_codes.createIndex({ code: 1 }, { unique: true })
db.licenses.createIndex({ userId: 1, status: 1 })
db.transaksi.createIndex({ clientId: 1 }, { unique: true, sparse: true })
db.memberships.createIndex({ clientId: 1 }, { unique: true, sparse: true })
db.kasbon.createIndex({ clientId: 1 }, { unique: true, sparse: true })
db.rekap_kas.createIndex({ clientId: 1 }, { unique: true, sparse: true })
```
Endpoint pelanggan, kasbon, dan rekap kas **tidak** perlu `RequirePlan("subscription")`
karena dipakai kedua paket (untuk offline, endpoint ini memang tidak dipanggil — datanya lokal).

### 5.3 Buat key pair Ed25519 (sekali saja)
```go
// cmd/genkey/main.go
package main

import (
    "crypto/ed25519"
    "crypto/rand"
    "encoding/base64"
    "fmt"
)

func main() {
    pub, priv, _ := ed25519.GenerateKey(rand.Reader)
    fmt.Println("LICENSE_PRIVATE_KEY=" + base64.StdEncoding.EncodeToString(priv))
    fmt.Println("LICENSE_PUBLIC_KEY=" + base64.StdEncoding.EncodeToString(pub))
}
```
- `LICENSE_PRIVATE_KEY` → `.env` server (rahasia, jangan di-commit).
- `LICENSE_PUBLIC_KEY` → ditanam di Flutter (aman, memang publik).

### 5.4 Generate kode aktivasi (admin)
```go
// POST /admin/activation-codes   body: {"userId": "..."}
// Lindungi dengan middleware superadmin / header X-Admin-Key.
func GenerateActivationCode(c *gin.Context) {
    var req struct{ UserID string `json:"userId" binding:"required"` }
    if err := c.ShouldBindJSON(&req); err != nil {
        c.JSON(400, gin.H{"message": "userId wajib diisi"}); return
    }
    uid, err := primitive.ObjectIDFromHex(req.UserID)
    if err != nil { c.JSON(400, gin.H{"message": "userId tidak valid"}); return }

    var user User
    if err := db.Collection("users").FindOne(c, bson.M{"_id": uid}).Decode(&user); err != nil {
        c.JSON(404, gin.H{"message": "user tidak ditemukan"}); return
    }
    if user.Plan != "offline" {
        c.JSON(400, gin.H{"message": "user bukan paket offline"}); return
    }

    code := newCode() // contoh: TKO-7K3M-Q9XP
    doc := ActivationCode{
        Code: code, UserID: uid, Status: "unused", CreatedBy: c.GetString("adminEmail"),
        CreatedAt: time.Now(), ExpiresAt: time.Now().Add(7 * 24 * time.Hour),
    }
    if _, err := db.Collection("activation_codes").InsertOne(c, doc); err != nil {
        c.JSON(500, gin.H{"message": "gagal membuat kode"}); return
    }
    c.JSON(200, gin.H{"data": gin.H{"code": code, "expiresAt": doc.ExpiresAt}})
}

// Tanpa huruf/angka yang mirip (0/O, 1/I/L) agar tidak salah ketik dari WA.
const codeAlphabet = "ABCDEFGHJKMNPQRSTUVWXYZ23456789"

func newCode() string {
    b := make([]byte, 8)
    rand.Read(b) // crypto/rand
    for i := range b { b[i] = codeAlphabet[int(b[i])%len(codeAlphabet)] }
    return "TKO-" + string(b[:4]) + "-" + string(b[4:])
}
```

### 5.5 Aktivasi kode (dipanggil aplikasi)
```go
// POST /license/activate   (Bearer token user)
// body: {"code":"TKO-7K3M-Q9XP","deviceId":"a1b2c3d4","deviceName":"Samsung A15"}
func ActivateLicense(c *gin.Context) {
    var req struct {
        Code       string `json:"code" binding:"required"`
        DeviceID   string `json:"deviceId" binding:"required"`
        DeviceName string `json:"deviceName"`
    }
    if err := c.ShouldBindJSON(&req); err != nil {
        c.JSON(400, gin.H{"message": "data tidak lengkap"}); return
    }
    uid := c.MustGet("userId").(primitive.ObjectID) // dari middleware JWT
    now := time.Now()

    // 1. Ambil & kunci kode secara atomik (status unused -> used), cegah dipakai 2x.
    var ac ActivationCode
    err := db.Collection("activation_codes").FindOneAndUpdate(c,
        bson.M{
            "code": strings.ToUpper(strings.TrimSpace(req.Code)),
            "userId": uid, "status": "unused", "expiresAt": bson.M{"$gt": now},
        },
        bson.M{"$set": bson.M{"status": "used", "usedAt": now, "deviceId": req.DeviceID}},
    ).Decode(&ac)
    if err != nil {
        c.JSON(400, gin.H{"message": "kode tidak valid, sudah dipakai, atau kadaluarsa"}); return
    }

    // 2. Ganti HP: cabut semua lisensi aktif sebelumnya milik user ini.
    db.Collection("licenses").UpdateMany(c,
        bson.M{"userId": uid, "status": "active"},
        bson.M{"$set": bson.M{"status": "revoked", "revokedAt": now}},
    )

    // 3. Terbitkan lisensi baru.
    lic := License{
        ID: primitive.NewObjectID(), UserID: uid, DeviceID: req.DeviceID,
        DeviceName: req.DeviceName, Status: "active", IssuedAt: now,
    }
    db.Collection("licenses").InsertOne(c, lic)

    var user User
    db.Collection("users").FindOne(c, bson.M{"_id": uid}).Decode(&user)

    // 4. Tanda tangani payload.
    payload, _ := json.Marshal(map[string]any{
        "licenseId": lic.ID.Hex(), "userId": uid.Hex(), "plan": "offline",
        "deviceId": req.DeviceID, "store": user.Store,
        "issuedAt": now.UTC().Format(time.RFC3339),
    })
    sig := ed25519.Sign(licensePrivateKey, payload)

    // payload dikirim sebagai base64 dari byte yang PERSIS ditandatangani,
    // supaya aplikasi tidak perlu men-serialize ulang JSON.
    c.JSON(200, gin.H{"data": gin.H{
        "payload":   base64.StdEncoding.EncodeToString(payload),
        "signature": base64.StdEncoding.EncodeToString(sig),
    }})
}

var licensePrivateKey = func() ed25519.PrivateKey {
    k, err := base64.StdEncoding.DecodeString(os.Getenv("LICENSE_PRIVATE_KEY"))
    if err != nil || len(k) != ed25519.PrivateKeySize { log.Fatal("LICENSE_PRIVATE_KEY tidak valid") }
    return ed25519.PrivateKey(k)
}()
```

### 5.6 Cek status lisensi
```go
// GET /license/status?licenseId=...   (Bearer token)
// balas {"data":{"status":"active"|"revoked"}}
```
Dipanggil aplikasi offline setiap kali kebetulan online, untuk mendeteksi revoke (ganti HP).

### 5.7 Middleware pembatas fitur subscription
Penting: aturan paket juga harus ditegakkan di server, bukan hanya disembunyikan di UI.
```go
func RequirePlan(plan string) gin.HandlerFunc {
    return func(c *gin.Context) {
        if c.GetString("plan") != plan { // plan diisi middleware JWT dari data user
            c.AbortWithStatusJSON(403, gin.H{"message": "fitur hanya untuk paket " + plan})
            return
        }
        c.Next()
    }
}

sub := r.Group("/", AuthJWT(), RequirePlan("subscription"))
sub.POST("/cabang", InsertCabang)
sub.POST("/pengiriman/:id/get-by-owner/direct", InsertPengiriman)
sub.POST("/obrolan/:id/get-by-owner/insert", InsertObrolan)
sub.POST("/register/:id/karyawan", RegisterKaryawan)
sub.POST("/sync/transaksi", SyncTransaksi)
sub.POST("/payments/midtrans/snap", CreateSnap)
sub.GET("/payments/midtrans/:noInvoice/status", MidtransStatus)

// Webhook TIDAK pakai JWT (dipanggil server Midtrans), diverifikasi via signature.
r.POST("/payments/midtrans/notification", MidtransNotification)
```
Login karyawan (role `Kasir`/`Gudang`) juga ditolak jika owner-nya (`parent`) berpaket offline.

### 5.8 Endpoint sync transaksi (idempotent)
Sudah dipanggil aplikasi (Fase 3, [sync_service.dart](../lib/services/sync_service.dart)).
Payload persis yang dikirim aplikasi (maks. 50 transaksi per request):
```json
{
  "pelanggan": [
    {"clientId":"uuid-p1","userId":"...","cabangId":"...","memberId":"MBR-A1B2-261022101500",
     "email":"","nik":"","name":"Budi","phone":"","address":""}
  ],
  "transaksi": [
    {"clientId":"uuid-t1","userId":"<id owner>","name":"<nama kasir>",
     "noInvoice":"INV-261022-A1B2-101500","cabangId":"...","date":"2026-10-22",
     "discountName":"","discountUnit":"Tidak ada","discountAmount":0,
     "subJumlahTransaksi":30000,"jumlahPembayaran":50000,"jumlahTransaksi":30000,"kembalian":20000,
     "membershipsId":"<_id server ATAU clientId pelanggan di batch ini>","memberId":"MBR-...",
     "kasbon": {"clientId":"uuid-k1","note":"","status":"Belum dibayar"},
     "items":[{"stokId":"...","produkId":"...","code":"BRG1","name":"Beras","harga":10000,"qty":3,"total":30000}]}
  ],
  "rekapKas": [
    {"clientId":"uuid-r1","karyawanId":"...","cabangId":"...","kasAwal":100000,"kasAkhir":0,"selisih":0,"date":"2026-10-22"}
  ]
}
```
Balasan yang diharapkan aplikasi (clientId dari semua jenis data digabung):
```json
{"data": {"accepted": ["uuid-p1","uuid-t1","uuid-r1"],
          "rejected": [{"clientId":"uuid-x","reason":"stok tidak ditemukan"}]}}
```
Yang `accepted` dihapus dari HP; yang `rejected` tetap di HP, ditandai alasannya, dan dikirim
ulang di sync berikutnya. Status selain 200 → semua data tetap di HP dan dicoba lagi.

```go
func SyncTransaksi(c *gin.Context) {
    var req struct {
        Pelanggan []PelangganSync `json:"pelanggan"`
        Transaksi []TransaksiSync `json:"transaksi"`
        RekapKas  []RekapKasSync  `json:"rekapKas"`
    }
    if err := c.ShouldBindJSON(&req); err != nil {
        c.JSON(400, gin.H{"message": "format salah"}); return
    }
    accepted := []string{}
    rejected := []gin.H{}
    hasil := func(clientId string, err error) {
        switch {
        case err == nil, mongo.IsDuplicateKeyError(err): // duplikat = sudah pernah tersimpan
            accepted = append(accepted, clientId)
        default:
            rejected = append(rejected, gin.H{"clientId": clientId, "reason": err.Error()})
        }
    }

    // 1. Pelanggan dulu: simpan dengan field clientId (unique index)
    for _, p := range req.Pelanggan { hasil(p.ClientID, savePelanggan(c, p)) }

    // 2. Transaksi, dalam 1 Mongo transaction per transaksi:
    //    - membershipsId: cari _id = membershipsId, jika tidak ada cari clientId = membershipsId
    //    - insert transaksi (clientId unik) + insert pesanan per item
    //    - kurangi stok-cabang ($inc qty: -item.qty), boleh minus (konflik antar cabang)
    //    - jika kasbon != nil: insert kasbon (clientId = kasbon.clientId, transaksiId = _id transaksi baru)
    //    - jika ada member: poin +100
    for _, t := range req.Transaksi { hasil(t.ClientID, saveTransaksiWithItems(c, t)) }

    // 3. Rekap kas
    for _, r := range req.RekapKas { hasil(r.ClientID, saveRekapKas(c, r)) }

    c.JSON(200, gin.H{"data": gin.H{"accepted": accepted, "rejected": rejected}})
}
```
Catatan:
- `noInvoice` dibuat HP dengan format `INV-{yyMMdd}-{4 char deviceId}-{HHmmss}`; jangan dibuat ulang di server.
- Jika `noInvoice` dibuat unique di server, pastikan duplikat noInvoice dengan `clientId` yang sama
  dianggap sukses (request terkirim dua kali), bukan error.
Catatan: endpoint `POST /transaksi` & `POST /pesanan/...` lama bisa tetap ada untuk
kompatibilitas, tapi untuk sync sebaiknya pakai endpoint gabungan di atas.

### 5.9 Midtrans (Snap)
`.env`:
```
MIDTRANS_SERVER_KEY=SB-Mid-server-xxxxxxxx
MIDTRANS_IS_PRODUCTION=false
```
Atur **Payment Notification URL** di Dashboard Midtrans → Settings → Payment →
`https://toko.tetrabit.my.id/api/payments/midtrans/notification`.

```go
func snapBaseURL() string {
    if os.Getenv("MIDTRANS_IS_PRODUCTION") == "true" { return "https://app.midtrans.com" }
    return "https://app.sandbox.midtrans.com"
}
func coreBaseURL() string {
    if os.Getenv("MIDTRANS_IS_PRODUCTION") == "true" { return "https://api.midtrans.com" }
    return "https://api.sandbox.midtrans.com"
}
func midtransAuth() string {
    return "Basic " + base64.StdEncoding.EncodeToString([]byte(os.Getenv("MIDTRANS_SERVER_KEY")+":"))
}

// POST /payments/midtrans/snap  body: {"noInvoice":"INV-...","amount":50000,"items":[...]}
func CreateSnap(c *gin.Context) {
    var req struct {
        NoInvoice string `json:"noInvoice" binding:"required"`
        Amount    int64  `json:"amount" binding:"required,gt=0"`
        Items     []struct {
            ID    string `json:"id"`
            Name  string `json:"name"`
            Price int64  `json:"price"`
            Qty   int    `json:"quantity"`
        } `json:"items"`
    }
    if err := c.ShouldBindJSON(&req); err != nil {
        c.JSON(400, gin.H{"message": "data tidak lengkap"}); return
    }
    // PENTING: hitung ulang amount dari harga di DB, jangan percaya angka dari aplikasi.

    body, _ := json.Marshal(gin.H{
        "transaction_details": gin.H{"order_id": req.NoInvoice, "gross_amount": req.Amount},
        "item_details":        req.Items, // total item harus = gross_amount (diskon = item harga negatif)
        "enabled_payments":    []string{"other_qris", "gopay", "shopeepay", "bca_va", "bni_va", "bri_va"},
        "expiry":              gin.H{"unit": "minutes", "duration": 15},
    })
    httpReq, _ := http.NewRequest("POST", snapBaseURL()+"/snap/v1/transactions", bytes.NewReader(body))
    httpReq.Header.Set("Authorization", midtransAuth())
    httpReq.Header.Set("Content-Type", "application/json")
    httpReq.Header.Set("Accept", "application/json")

    resp, err := http.DefaultClient.Do(httpReq)
    if err != nil { c.JSON(502, gin.H{"message": "midtrans tidak dapat dihubungi"}); return }
    defer resp.Body.Close()

    var out struct {
        Token       string   `json:"token"`
        RedirectURL string   `json:"redirect_url"`
        Errors      []string `json:"error_messages"`
    }
    json.NewDecoder(resp.Body).Decode(&out)
    if resp.StatusCode != 201 {
        c.JSON(400, gin.H{"message": strings.Join(out.Errors, ", ")}); return
    }

    // simpan status awal
    db.Collection("payments").UpdateOne(c,
        bson.M{"noInvoice": req.NoInvoice},
        bson.M{"$set": bson.M{"status": "pending", "amount": req.Amount, "ownerId": c.MustGet("userId"), "updatedAt": time.Now()}},
        options.Update().SetUpsert(true))

    c.JSON(200, gin.H{"data": gin.H{"snapToken": out.Token, "redirectUrl": out.RedirectURL}})
}

// POST /payments/midtrans/notification  (dipanggil server Midtrans)
func MidtransNotification(c *gin.Context) {
    var n struct {
        OrderID           string `json:"order_id"`
        StatusCode        string `json:"status_code"`
        GrossAmount       string `json:"gross_amount"`
        SignatureKey      string `json:"signature_key"`
        TransactionStatus string `json:"transaction_status"`
        FraudStatus       string `json:"fraud_status"`
        PaymentType       string `json:"payment_type"`
    }
    if err := c.ShouldBindJSON(&n); err != nil { c.Status(400); return }

    // Verifikasi: SHA512(order_id + status_code + gross_amount + ServerKey)
    h := sha512.Sum512([]byte(n.OrderID + n.StatusCode + n.GrossAmount + os.Getenv("MIDTRANS_SERVER_KEY")))
    if hex.EncodeToString(h[:]) != n.SignatureKey { c.Status(403); return }

    status := "pending"
    switch n.TransactionStatus {
    case "capture":
        if n.FraudStatus == "accept" { status = "paid" }
    case "settlement":
        status = "paid"
    case "deny", "cancel", "expire", "failure":
        status = "failed"
    case "refund", "partial_refund":
        status = "refunded"
    }

    db.Collection("payments").UpdateOne(c, bson.M{"noInvoice": n.OrderID},
        bson.M{"$set": bson.M{"status": status, "paymentType": n.PaymentType, "updatedAt": time.Now()}})

    // Opsional: broadcast ke WebSocket channel owner agar kasir langsung tahu.
    c.Status(200) // wajib 200, kalau tidak Midtrans akan retry
}

// GET /payments/midtrans/:noInvoice/status → {"data":{"status":"paid"}}
```
Transaksi + pesanan baru disimpan ke koleksi `transaksi` setelah status `paid`
(atau simpan dengan `status: "pending"` lalu update — pilih salah satu dan konsisten).

---

## 6. Rencana implementasi Flutter (bertahap)

| Fase | Isi | File utama yang disentuh |
|---|---|---|
| **1. Paket & aktivasi** | Halaman pilih paket di register, field `plan` di model & storage, `PlanService`, `LicenseService` (verifikasi Ed25519 + deviceId), halaman input kode, `autoLogin` baru, feature gating navbar/menu | `signup.dart`, `post_register_o_api.dart`, `post_login_o_api.dart`, `auth_controllers.dart`, `user.dart`, `user_owner.dart`, `navbar.dart`, `index_screens.dart`, `route.dart`, `payment_detail.dart` (teks WA beda per paket) |
| **2. DB lokal & mode offline** | `local_db.dart`, repository stok/produk/kategori/merk/transaksi/pelanggan/kasbon/rekap kas versi lokal, `AddKasir.checkout()` via repository (transaksi + kasbon + poin dalam 1 DB transaction), nomor invoice & member ID di HP, laporan & laporan kasbon dari SQL lokal, cetak struk tetap jalan | `kasir_controllers.dart`, `stok_controllers.dart`, `get_stok.dart`, `get_transaksi.dart`, `get_report_produk.dart`, `summary_chart_controller.dart`, `pelanggan_controller.dart`, `get_pelanggan.dart`, `post_insert_pelanggan.dart`, `put_update_point_pelanggan_by_id.dart`, `kasbon_controllers.dart`, `get_kasbon.dart`, `post_insert_kasbon.dart`, `kas_controllers.dart`, `get_rekap_kas.dart`, `post_insert_rekap_kas.dart`, `put_update_kas_by_id.dart` |
| **3. Offline-first subscription** | Outbox transaksi, `SyncService` + `connectivity_plus`, cache master data, indikator "X transaksi belum tersinkron" | `sync_service.dart`, `app_binding.dart`, homepage |
| **4. Midtrans** | Tombol "Bayar Online" di pembayaran, `MidtransService`, webview Snap, polling status, hapus `xendit_controller.dart` | `body_pembayaran.dart`, `midtrans_service.dart` |
| **5. Backup/Restore (offline)** ✓ | Menu "Backup & Restore" (khusus paket offline): semua tabel + foto produk jadi satu file `.json`, dibagikan lewat share sheet (WA/Drive/email). Restore hanya untuk backup akun yang sama, mengganti seluruh data dalam 1 DB transaction, foto ditulis ulang ke folder HP baru | [local_backup_repository.dart](../lib/repositories/local_backup_repository.dart), [backup_page.dart](../lib/modules/Backup/mobile_ui/backup_page.dart) |

Fase 1 & 2 adalah inti paket offline; fase 3 & 4 untuk subscription.

---

## 7. Keamanan — perlu tindakan segera

1. **Secret key Xendit pernah ada di aplikasi** (`xendit_controller.dart`, sudah dihapus di Fase 4).
   Key itu tetap ada di riwayat git dan APK lama, jadi **revoke di dashboard Xendit**.
   Midtrans Server Key **hanya** di backend.
2. Webhook Midtrans wajib verifikasi `signature_key`, dan nominal Snap dihitung ulang di
   server dari data produk/stok, bukan dari angka kiriman aplikasi.
3. Aturan paket (fitur subscription) ditegakkan di backend (middleware `RequirePlan`),
   karena UI yang disembunyikan bisa dilewati dengan memanggil API langsung.
4. `LICENSE_PRIVATE_KEY` & `MIDTRANS_SERVER_KEY` di `.env`, tidak di-commit ke git.
