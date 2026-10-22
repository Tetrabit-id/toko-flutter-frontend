// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:diatera_pos/routes/base_url.dart';
import 'package:diatera_pos/routes/state_global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertPelangganAPI extends GetxController {
  // Tombol Fungsi insert pelanggan
  Future<void> connectAPI(
    String? userId,
    String cabangId,
    String memberId,
    String nik,
    String email,
    String name,
    String phone,
    String? address,
  ) async {
    try {
      var response = await http.post(Uri.parse('$baseUrl/memberships'),
          body: json.encode({
            'userId': userId,
            'cabangId': cabangId,
            'memberId': memberId,
            'email': email,
            'nik': nik,
            'name': name.capitalizeFirst,
            'phone': phone,
            'address': address,
            'poin': 0,
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
      snackbarNotif.success('Success', 'Pelanggan telah ditambahkan');

      pelanggan.emailNewPlgnC.clear();
      pelanggan.nameNewPlgnC.clear();
      pelanggan.phoneNewPlgnC.clear();
      pelanggan.addressNewPlgnC.clear();
      pelanggan.nikNewPlgnC.clear();
      pelanggan.cabangIdPlgnC = '';
      nfc.dataNfc.value = '';
      //
    } catch (e) {
      print(e);
    }
  }
}
