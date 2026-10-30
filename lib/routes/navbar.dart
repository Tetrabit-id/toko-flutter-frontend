import 'package:tetrabit_toko_pos/style/styles.dart';
import 'package:flutter/material.dart';

final navbar = [
  NavigationDestination(
      selectedIcon: NavSvg.homeSelectedSvg,
      icon: NavSvg.homeSvg,
      label: "Beranda"),
  NavigationDestination(
      selectedIcon: NavSvg.stokSelectedSvg,
      icon: NavSvg.stokSvg,
      label: "Stok"),
  NavigationDestination(
      selectedIcon: NavSvg.kasirSelectedSvg,
      icon: NavSvg.kasirSvg,
      label: "Kasir"),
  NavigationDestination(
      selectedIcon: NavSvg.userSelectedSvg,
      icon: NavSvg.userSvg,
      label: "Pengguna"),
  NavigationDestination(
      selectedIcon: NavSvg.laporanSelectedSvg,
      icon: NavSvg.laporanSvg,
      label: "Laporan"),
];

final navbarKasir = [
  NavigationDestination(
      selectedIcon: NavSvg.kasirSelectedSvg,
      icon: NavSvg.kasirSvg,
      label: "Kasir"),
  NavigationDestination(
      selectedIcon: NavSvg.stokSelectedSvg,
      icon: NavSvg.stokSvg,
      label: "Stok"),
];

final navbarStok = [
  NavigationDestination(
      selectedIcon: NavSvg.stokSelectedSvg,
      icon: NavSvg.stokSvg,
      label: "Stok"),
  NavigationDestination(
      selectedIcon: NavSvg.laporanSelectedSvg,
      icon: NavSvg.laporanSvg,
      label: "Laporan"),
];
