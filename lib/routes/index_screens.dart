import '../modules/Home/mobile_ui/homepage.dart';
import '../modules/Laporan/mobile_ui/laporan.dart';
import '../modules/Stok/mobile_ui/stok.dart';
import '../modules/User/mobile_ui/sub_users.dart';
import '../modules/Kasir/tab_ui/kasir_tablet.dart';
import '../modules/Stok/tab_ui/stok_tablet.dart';
import '../modules/User/tab_ui/sub_users_tablet.dart';
import '../modules/Kasir/mobile_ui/kasir.dart';

final screens = [
  const HomePageMobile(),
  const StokPage(),
  const KasirPage(),
  const SubUserPage(),
  const LaporanPage(),
];

final screensTablet = [
  const HomePageMobile(),
  const StokPageforTablet(),
  const KasirPageforTablet(),
  const SubUserPageforTablet(),
  const LaporanPage(),
];

final screensKasir = [
  const KasirPage(),
  const StokPage(),
];

final screensKasirTablet = [
  const KasirPageforTablet(),
  const StokPageforTablet(),
];

final screensStok = [
  const StokPage(),
  const LaporanPage(),
];

final screensStokTablet = [
  const StokPageforTablet(),
  const LaporanPage(),
];
