// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/state_global.dart';
import '../../routes/base_url.dart';

class GetTransaksiAPI extends GetxController {
  final dataLaporan = List.empty().obs;
  late List dataLaporanHariIni = List.empty().obs;

  // Function Get Semua Data Transaksi
  Future<List> getApi() async {
    // Paket offline: dari DB lokal
    if (paket.isOffline) {
      dataLaporan.assignAll(await localTransaksi.getTransaksi());
      return dataLaporan;
    }

    // Subscription tanpa koneksi: cache terakhir + transaksi yang belum terkirim
    if (koneksi.terputus) {
      dataLaporan.assignAll(await localTransaksi.getTransaksi());
      return dataLaporan;
    }

    try {
      var idOwner = token.read('role') != 'admin'
          ? token.read('parentId')
          : token.read('_id');
      var response = await http.get(
        Uri.parse('$baseUrl/transaksi/$idOwner/get-by-owner/all/cabang'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      // Jika gagal get data transaksi
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );

        return dataLaporan;
      }
      //

      if (dataLaporan.isNotEmpty) {
        dataLaporan.clear();
        dataLaporan.refresh();
      }

      var laporanData = (data as Map<String, dynamic>)['data'];
      dataLaporan.addAll(laporanData);
      await localTransaksi.cacheTransaksi(laporanData);
      // Transaksi offline yang belum terkirim tetap terhitung di laporan
      dataLaporan.addAll(await localTransaksi.getPending());
      return dataLaporan;
    } catch (e) {
      print(e);
      dataLaporan.assignAll(await localTransaksi.getTransaksi());
    }
    return dataLaporan;
  }
}
