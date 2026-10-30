// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:tetrabit_toko_pos/routes/base_url.dart';
import 'package:tetrabit_toko_pos/routes/state_global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertKasbonAPI extends GetxController {
  // Tombol Fungsi insert kasbon
  Future<void> connectAPI(
    String? userId,
    String cabangId,
    String membershipsId,
    String memberId,
    String transaksiId,
    String note,
    String date,
  ) async {
    try {
      var response = await http.post(Uri.parse('$baseUrl/kasbon'),
          body: json.encode({
            'userId': userId,
            'cabangId': cabangId,
            'membershipsId': membershipsId,
            'memberId': memberId,
            'transaksiId': transaksiId,
            'note': note,
            'date': date,
            'status': 'Belum dibayar',
          }),
          headers: {'Authorization': 'Bearer ${token.read('token')}'});

      var data = jsonDecode(response.body);
      // Insert Gagal
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess('Unsuccess ${response.statusCode}',
            '${(data['message']).toString().capitalizeFirst}');
        return;
      }

      // Insert Success
      snackbarNotif.success('Success', 'Kasbon telah ditambahkan');
      //
    } catch (e) {
      print(e);
    }
  }
}
