// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:tetrabit_toko_pos/constructors/text_style.dart';
import 'package:tetrabit_toko_pos/routes/base_url.dart';
import 'package:tetrabit_toko_pos/routes/state_global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DataRegisterKaryawanAPI extends GetxController {
  // Tombol Fungsi Register Karyawan
  Future<void> connectAPI(
    String cabangId,
    String email,
    String password,
    String name,
    String store,
    String parent,
    String role,
  ) async {
    try {
      var passwordBase64 = base64Url.encode(utf8.encode(password));
      var response = await http
          .post(Uri.parse('$baseUrl/users/${token.read('_id')}/karyawan'),
              body: json.encode({
                'cabangId': cabangId,
                'email': email,
                'name': capitalizeEachWord(name),
                'password': passwordBase64,
                'parent': parent,
                'role': role,
                'store': store,
              }),
              headers: {'Authorization': 'Bearer ${token.read('token')}'});

      var data = jsonDecode(response.body);
      // Register Gagal
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess('Unsuccess ${response.statusCode}',
            '${(data['message']).toString().capitalizeFirst}');
        return;
      }

      // Register Success
      snackbarNotif.success('Success', 'Karyawan telah ditambahkan');

      karyawan.emailNewKryC.clear();
      karyawan.nameNewKryC.clear();
      karyawan.pwNewKryC.clear();
      karyawan.cabangIdKryC = '';
      karyawan.role = 'Kasir';
      karyawan.isSelected = [true, false];
    } catch (e) {
      print(e);
    }
  }
}
