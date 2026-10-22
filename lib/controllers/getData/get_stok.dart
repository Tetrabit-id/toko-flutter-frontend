// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/base_url.dart';
import '../../routes/state_global.dart';

class GetStokAPI extends GetxController {
  final dataStok = List.empty().obs;

  // Function Get Data Stok
  Future<List> getAPI(String? id, String? idCabang) async {
    // Paket offline: dari DB lokal
    if (paket.isOffline) {
      dataStok.assignAll(await localStok.getStok());
      return dataStok;
    }

    // Subscription tanpa koneksi: dari cache terakhir
    if (koneksi.terputus) {
      dataStok.assignAll(await localStok.getStok(cabangId: idCabang));
      return dataStok;
    }

    try {
      var response = await http.get(
        Uri.parse(
            '$baseUrl/stok-cabang/$id/get-by-owner/$idCabang/cabang/mobile'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      // Jika gagal get data stok
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );
        return dataStok;
      }
      //

      if (dataStok.isNotEmpty) {
        dataStok.clear();
        dataStok.refresh();
      }

      var stokData = (data as Map<String, dynamic>)['data'];
      dataStok.addAll(stokData);
      localStok.cacheStok(idCabang, stokData);

      return dataStok;
    } catch (e) {
      print(e);
      dataStok.assignAll(await localStok.getStok(cabangId: idCabang));
    }
    return dataStok;
  }
}
