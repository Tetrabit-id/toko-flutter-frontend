import 'package:get/get.dart';

import '../config/env.dart';
import '../routes/base_url.dart';

enum AppPlan { subscription, offline }

// Info paket untuk halaman pilih paket & pembayaran.
class PlanInfo {
  final AppPlan plan;
  final String nama;
  final String harga;
  final String masaAktif;
  final List<String> fitur;

  const PlanInfo({
    required this.plan,
    required this.nama,
    required this.harga,
    required this.masaAktif,
    required this.fitur,
  });

  String get value => plan.name;
}

const planSubscription = PlanInfo(
  plan: AppPlan.subscription,
  nama: 'Paket Subscription',
  harga: Env.hargaSubscription,
  masaAktif: 'Lifetime : 30 hari',
  fitur: [
    'Multi Cabang & Kirim Stok',
    'Chat antar Cabang',
    'Karyawan & Login Karyawan',
    'Pembayaran Online (QRIS/VA)',
    'Kasir tetap jalan saat offline',
    'Laporan Transaksi',
  ],
);

const planOffline = PlanInfo(
  plan: AppPlan.offline,
  nama: 'Paket Offline',
  harga: Env.hargaOffline,
  masaAktif: 'Aktivasi kode : 1 perangkat',
  fitur: [
    'Kasir tanpa internet',
    'Kelola Stok Pusat',
    'Pelanggan, Kasbon & Rekap Kas',
    'Connect to Printer Bluetooth',
    'Laporan Transaksi',
  ],
);

class PlanService extends GetxController {
  AppPlan get plan =>
      token.read('plan') == 'offline' ? AppPlan.offline : AppPlan.subscription;

  PlanInfo get info => isOffline ? planOffline : planSubscription;

  bool get isOffline => plan == AppPlan.offline;
  bool get canMultiCabang => !isOffline;
  bool get canKirimStok => !isOffline;
  bool get canChat => !isOffline;
  bool get canKelolaKaryawan => !isOffline;
  bool get canPaymentGateway => !isOffline;
}
