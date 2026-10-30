import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class AppColors {
  static const primaryColor = Color.fromARGB(255, 70, 191, 26);
  static const secondaryColor = Color.fromARGB(255, 70, 191, 26);
  static const bgGrey = Color.fromARGB(248, 246, 246, 246);
  static const colorFontSecond = Color.fromARGB(255, 171, 166, 166);
  static const borderColor = Color.fromARGB(255, 169, 169, 170);
  static const colorFontPrimary = Color.fromRGBO(49, 49, 49, 1);
  static const colorBgButton = Color.fromARGB(255, 215, 215, 215);
}

class AppImages {
  static var logoIconic = Image.asset('assets/img/logo_toko.png');
  static var logoFull = Image.asset('assets/img/logo_toko.png', width: 50);
  static var logoGoogle = Image.asset('assets/img/google.png');
  static var logoBCA = Image.asset('assets/img/logo_bca.png');
}

class AppSvg {
  static var welcomeSvg = SvgPicture.asset('assets/svg/welcome.svg');
  static var stokSvg = SvgPicture.asset('assets/svg/stok.svg');
  static var userSvg = SvgPicture.asset('assets/svg/user.svg');
  static var cabangSvg = SvgPicture.asset('assets/svg/cabang.svg');
  static var paymentInfoSvg = SvgPicture.asset('assets/svg/payment_info.svg');
  static var notFoundUserSvg =
      SvgPicture.asset('assets/svg/not_found_user.svg');
  static var notFoundChartSvg =
      SvgPicture.asset('assets/svg/not_found_chart.svg');
  static var notFoundLaporanSvg =
      SvgPicture.asset('assets/svg/not_found_laporan.svg');
  static var notFoundStokSvg =
      SvgPicture.asset('assets/svg/not_found_stok.svg');
  static var notFoundOrderanSvg =
      SvgPicture.asset('assets/svg/not_found_orderan.svg');
  static var availableStokSvg =
      SvgPicture.asset('assets/svg/available_stok.svg');
}

const _primary = ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn);

class NavSvg {
  static var homeSvg = SvgPicture.asset('assets/svg/home_nav.svg',
      colorFilter: _primary);
  static var stokSvg = SvgPicture.asset('assets/svg/stok_nav.svg',
      colorFilter: _primary);
  static var kasirSvg = SvgPicture.asset('assets/svg/kasir_nav.svg',
      colorFilter: _primary);
  static var userSvg = SvgPicture.asset('assets/svg/user_nav.svg',
      colorFilter: _primary);
  static var laporanSvg = SvgPicture.asset('assets/svg/laporan_nav.svg',
      colorFilter: _primary);
  static var homeSelectedSvg = SvgPicture.asset(
      'assets/svg/home_nav_selected.svg',
      colorFilter: _primary);
  static var stokSelectedSvg = SvgPicture.asset(
      'assets/svg/stok_nav_selected.svg',
      colorFilter: _primary);
  static var kasirSelectedSvg = SvgPicture.asset(
      'assets/svg/kasir_nav_selected.svg',
      colorFilter: _primary);
  static var userSelectedSvg = SvgPicture.asset(
      'assets/svg/user_nav_selected.svg',
      colorFilter: _primary);
  static var laporanSelectedSvg = SvgPicture.asset(
      'assets/svg/laporan_nav_selected.svg',
      colorFilter: _primary);
}

final current =
    NumberFormat.currency(locale: "en", symbol: "Rp. ", decimalDigits: 0);

String dateFormat(String date) {
  return DateFormat('EEEE, d MMMM y').format(DateTime.parse(date));
}

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 110 &&
      MediaQuery.of(context).size.width >= 650;
}
