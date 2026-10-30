import 'package:get/get.dart';
import '../modules/NFCReader/nfcreader.dart';
import '../modules/Obrolan/mobile_ui/obrolan.dart';
import '../modules/InfoPembayaranPage/mobile_ui/payment_detail.dart';
import '../modules/Obrolan/mobile_ui/pesan.dart';
import '../modules/Pelanggan/mobile_ui/pelanggan.dart';
import '../modules/RekapKas/mobile_ui/add_rekap_kas.dart';
import '../modules/RekapKas/mobile_ui/rekap_kas.dart';
import '../modules/start_page.dart';
import '../modules/EmptyPage/mobile_ui/add_nama_toko.dart';
import '../modules/DetailPage/mobile_ui/detail_pendapatan.dart';
import '../modules/InfoPembayaranPage/mobile_ui/payment_info_owner.dart';
import '../modules/InfoPembayaranPage/mobile_ui/payment_info_karyawan.dart';
import '../modules/Stok/mobile_ui/add_cabang.dart';
import '../modules/Stok/mobile_ui/add_stok.dart';
import '../modules/Home/mobile_ui/homepage.dart';
import '../modules/Kasir/mobile_ui/kasir.dart';
import '../modules/Laporan/mobile_ui/laporan.dart';
import '../modules/Login/mobile_ui/login.dart';
import '../modules/Register/mobile_ui/signup.dart';
import '../modules/Stok/mobile_ui/stok.dart';
import '../modules/FirstPage/mobile_ui/welcomepage.dart';
import '../modules/Kasir/tab_ui/kasir_tablet.dart';
import '../modules/Navbar/role_admin/index.dart';
import '../modules/Navbar/role_kasir/index_kasir.dart';
import '../modules/Navbar/role_gudang/index_gudang.dart';
import '../modules/Pelanggan/mobile_ui/add_pelanggan.dart';
import '../modules/User/mobile_ui/add_user.dart';
import '../modules/User/mobile_ui/sub_users.dart';
import '../modules/Register/mobile_ui/choose_plan.dart';
import '../modules/Aktivasi/mobile_ui/aktivasi_kode.dart';
import '../modules/Backup/mobile_ui/backup_page.dart';
import 'plan_middleware.dart';
import 'state_global.dart';

abstract class RouteName {
  static const start = '/';
  static const aktivasi = '/mobile/aktivasi';
  static const backup = '/index/backup';
  static const choosePlan = '/mobile/choose_plan';
  static const addStok = '/mobile/add_stok';
  static const addCabang = '/mobile/add_cabang';
  static const addUser = '/mobile/add_user';
  static const addPelanggan = '/mobile/add_pelanggan';
  static const addRekapKas = '/mobile/add_rekap_kas';
  static const detail = '/mobile/detail_pendapatan';
  static const firstAddToko = '/mobile/add_nama_toko';
  static const firstPageMobile = '/mobile';
  static const homeMobile = '/mobile/home';
  static const index = '/index';
  static const indexKasir = '/index_kasir';
  static const indexGudang = '/index_stok';
  static const kasir = '/index/kasir';
  static const kasirForTablet = '/index/kasir/tablet';
  static const nfc = '/kasir/nfc';
  static const laporan = '/index/laporan';
  static const loginMobile = '/mobile/login';
  static const obrolan = '/index/obrolan';
  static const pesan = '/index/pesan';
  static const pelanggan = '/index/pelanggan';
  static const paymentDetail = '/payment_detail';
  static const paymentInfoForKaryawan = '/payment_karyawan';
  static const paymentInfoForOwner = '/payment_owner';
  static const rekapKas = '/index/rekap_kas';
  static const signUpMobile = '/mobile/signup';
  static const stok = '/index/stok';
  static const user = '/index/user';
}

class AppPages {
  static final pages = [
    GetPage(name: RouteName.start, page: () => const StartPage()),
    GetPage(name: RouteName.aktivasi, page: () => const AktivasiKodePage()),
    GetPage(
        name: RouteName.backup,
        page: () => const BackupPage(),
        middlewares: [PlanMiddleware(() => paket.isOffline)]),
    GetPage(name: RouteName.choosePlan, page: () => const ChoosePlanPage()),
    GetPage(
        name: RouteName.addCabang,
        page: () => const AddCabangPage(),
        middlewares: [PlanMiddleware(() => paket.canMultiCabang)]),
    GetPage(name: RouteName.addStok, page: () => const AddStokPage()),
    GetPage(
        name: RouteName.addUser,
        page: () => const AddUserPage(),
        middlewares: [PlanMiddleware(() => paket.canKelolaKaryawan)]),
    GetPage(name: RouteName.addPelanggan, page: () => const AddPelangganPage()),
    GetPage(name: RouteName.addRekapKas, page: () => const AddRekapKasPage()),
    GetPage(name: RouteName.detail, page: () => const DetailPage()),
    GetPage(
        name: RouteName.firstPageMobile, page: () => const WelcomePageMobile()),
    GetPage(name: RouteName.firstAddToko, page: () => const AddNamaTokoPage()),
    GetPage(name: RouteName.kasir, page: () => const KasirPage()),
    GetPage(
        name: RouteName.kasirForTablet, page: () => const KasirPageforTablet()),
    GetPage(name: RouteName.homeMobile, page: () => const HomePageMobile()),
    GetPage(name: RouteName.index, page: () => const IndexPage()),
    GetPage(name: RouteName.indexKasir, page: () => const IndexKasirPage()),
    GetPage(name: RouteName.indexGudang, page: () => const IndexGudangPage()),
    GetPage(name: RouteName.laporan, page: () => const LaporanPage()),
    GetPage(name: RouteName.loginMobile, page: () => const LoginPageMobile()),
    GetPage(
        name: RouteName.obrolan,
        page: () => const ObrolanPage(),
        middlewares: [PlanMiddleware(() => paket.canChat)]),
    GetPage(
        name: RouteName.pesan,
        page: () => const PesanPage(),
        middlewares: [PlanMiddleware(() => paket.canChat)]),
    GetPage(
        name: RouteName.paymentDetail, page: () => const PaymentDetailPage()),
    GetPage(
        name: RouteName.paymentInfoForKaryawan,
        page: () => const PaymentInfoForKaryawan()),
    GetPage(
        name: RouteName.paymentInfoForOwner,
        page: () => const PaymentInfoForOwner()),
    GetPage(name: RouteName.pelanggan, page: () => const PelangganPage()),
    GetPage(name: RouteName.rekapKas, page: () => const RekapKasPage()),
    GetPage(name: RouteName.signUpMobile, page: () => const SignUpPageMobile()),
    GetPage(name: RouteName.stok, page: () => const StokPage()),
    GetPage(
        name: RouteName.user,
        page: () => const SubUserPage(),
        middlewares: [PlanMiddleware(() => paket.canKelolaKaryawan)]),
    GetPage(name: RouteName.nfc, page: () => const NFCReader()),
  ];
}
