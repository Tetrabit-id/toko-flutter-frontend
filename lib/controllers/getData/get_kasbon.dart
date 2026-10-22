// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/base_url.dart';
import '../../routes/state_global.dart';

class GetKasbonAPI extends GetxController {
  final dataKasbon = List.empty().obs;

  // Function Get Data Pesanan
  Future<List> getApi() async {
    // Paket offline: dari DB lokal
    // Subscription tanpa koneksi: cache terakhir + kasbon yang belum terkirim
    if (paket.isOffline || koneksi.terputus) {
      dataKasbon.assignAll(await localPelanggan.getKasbon());
      return dataKasbon;
    }

    try {
      var response = await http.get(
        Uri.parse(
            '$baseUrl/kasbon/${token.read('_id')}/get-by-owner/all/cabang'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      // Jika gagal get data pesanan
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );

        return dataKasbon;
      }
      //

      if (dataKasbon.isNotEmpty) {
        dataKasbon.clear();
        dataKasbon.refresh();
      }

      var kasbonData = (data as Map<String, dynamic>)['data'];
      dataKasbon.addAll(kasbonData);
      await localPelanggan.cacheKasbon(kasbonData);
      // termasuk kasbon dari transaksi offline yang belum terkirim
      dataKasbon.addAll(await localPelanggan.getPendingKasbon());

      return dataKasbon;
    } catch (e) {
      print(e);
      dataKasbon.assignAll(await localPelanggan.getKasbon());
    }
    return dataKasbon;
  }
}
