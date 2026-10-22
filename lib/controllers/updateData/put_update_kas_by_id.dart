// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:diatera_pos/routes/base_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/state_global.dart';

class UpdateRekapKasAPI extends GetxController {
  Future<void> connectAPI(
    String idRekapKas,
    int? kasAkhir,
    int? selisih,
  ) async {
    try {
      var response = await http.put(
          Uri.parse(
              '$baseUrl/rekap-kas/${token.read('_id')}/get-by-owner/$idRekapKas/update'),
          body: json.encode({
            'kasAkhir': kasAkhir,
            'selisih': selisih,
          }),
          headers: {'Authorization': 'Bearer ${token.read('token')}'});

      var data = jsonDecode(response.body);

      // Update Produk Gagal
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );

        return;
      }

      // Update Success
      Get.back();
      snackbarNotif.success('Success', 'Tutup buku berhasil');
      rekapKas.kasAkhirNewRekapC.clear();

      //
    } catch (e) {
      print(e);
    }
  }
}
