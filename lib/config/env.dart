// Konfigurasi per lingkungan, diisi saat build dari file env/*.json:
//   flutter run --dart-define-from-file=env/dev.json
//   flutter build apk --dart-define-from-file=env/prod.json
// Nilai ini ikut tertanam di aplikasi (bisa dibaca dari APK),
// jadi jangan isi rahasia; rahasia tetap di backend.
class Env {
  static const baseUrl = String.fromEnvironment('BASE_URL');
  static const baseUrlWS = String.fromEnvironment('BASE_URL_WS');

  // Public key Ed25519 dari backend (output LICENSE_PUBLIC_KEY di cmd/genkey)
  static const licensePublicKey = String.fromEnvironment('LICENSE_PUBLIC_KEY');

  // Pembayaran paket via transfer + konfirmasi WhatsApp
  static const waAdmin = String.fromEnvironment('WA_ADMIN');
  static const rekeningNo = String.fromEnvironment('REKENING_NO');
  static const rekeningNama = String.fromEnvironment('REKENING_NAMA');

  static const hargaSubscription = String.fromEnvironment('HARGA_SUBSCRIPTION',
      defaultValue: '100K / bulan');
  static const hargaOffline =
      String.fromEnvironment('HARGA_OFFLINE', defaultValue: 'Hubungi Admin');

  // Gagal di awal dengan pesan jelas jika app dijalankan tanpa file env
  static void validate() {
    var missing = {
      'BASE_URL': baseUrl,
      'BASE_URL_WS': baseUrlWS,
      'LICENSE_PUBLIC_KEY': licensePublicKey,
      'WA_ADMIN': waAdmin,
      'REKENING_NO': rekeningNo,
      'REKENING_NAMA': rekeningNama,
    }.entries.where((e) => e.value.isEmpty).map((e) => e.key);

    if (missing.isNotEmpty) {
      throw StateError(
        'Konfigurasi belum diisi: ${missing.join(', ')}. '
        'Jalankan dengan --dart-define-from-file=env/dev.json '
        '(salin dari env/example.json).',
      );
    }
  }
}
