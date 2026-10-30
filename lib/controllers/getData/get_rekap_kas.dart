// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/base_url.dart';
import '../../routes/state_global.dart';

class GetRekapKasAPI extends GetxController {
  final dataKas = List.empty().obs;

  // Function Get Data Pelanggan
  Future<List> getApi() async {
    // Paket offline: dari DB lokal
    // Subscription tanpa koneksi: cache terakhir + rekap kas yang belum terkirim
    if (paket.isOffline || koneksi.terputus) {
      dataKas.assignAll(await localRekapKas.getRekapKas());
      return dataKas;
    }

    try {
      var response = await http.get(
        Uri.parse(
            '$baseUrl/rekap-kas/${token.read('_id')}/get-by-owner/all/cabang'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      // Jika gagal get data pelanggan
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );

        return dataKas;
      }
      //

      if (dataKas.isNotEmpty) {
        dataKas.clear();
        dataKas.refresh();
      }

      var rekapKasData = (data as Map<String, dynamic>)['data'];
      dataKas.addAll(rekapKasData);
      await localRekapKas.cacheRekapKas(rekapKasData);
      // termasuk rekap kas yang dibuat offline dan belum terkirim
      dataKas.addAll(await localRekapKas.getPending());
      return dataKas;
    } catch (e) {
      print(e);
      dataKas.assignAll(await localRekapKas.getRekapKas());
    }
    return dataKas;
  }
}
