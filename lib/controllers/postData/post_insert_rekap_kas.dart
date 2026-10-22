// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:diatera_pos/routes/base_url.dart';
import 'package:diatera_pos/routes/state_global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertRekapKasAPI extends GetxController {
  // Tombol Fungsi insert pelanggan
  Future<void> connectAPI(
    String? userId,
    String cabangId,
    int kasAwal,
  ) async {
    try {
      var response = await http
          .post(Uri.parse('$baseUrl/rekap-kas/$userId/get-by-owner/insert'),
              body: json.encode({
                'karyawanId': userId,
                'cabangId': cabangId,
                'kasAwal': kasAwal,
                'kasAkhir': 0,
              }),
              headers: {'Authorization': 'Bearer ${token.read('token')}'});

      var data = jsonDecode(response.body);
      // Insert Gagal
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess('Unsuccess ${response.statusCode}',
            '${(data['message']).toString().capitalizeFirst}');
        return;
      }

      // Register Success
      snackbarNotif.success('Success', 'Rekap kas telah ditambahkan');

      rekapKas.kasAwalNewRekapC.clear();
      rekapKas.cabangIdRekapC = '';
      //
    } catch (e) {
      print(e);
    }
  }
}
