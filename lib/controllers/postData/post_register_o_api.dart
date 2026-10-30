// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:tetrabit_toko_pos/routes/state_global.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tetrabit_toko_pos/routes/route.dart';
import 'package:tetrabit_toko_pos/routes/base_url.dart';

class DataRegisterOwnerAPI extends GetxController {
  // TextEditorControl for Register
  TextEditingController usernameNewC = TextEditingController();
  TextEditingController emailNewC = TextEditingController();
  TextEditingController storeNewC = TextEditingController();
  TextEditingController passwordNewC = TextEditingController();
  TextEditingController repasswordNewC = TextEditingController();

  // Paket yang dipilih di halaman pilih paket: subscription | offline
  String plan = 'subscription';

  // FirebaseAuth auth = FirebaseAuth.instance;

  // Tombol Fungsi Register
  Future<void> connectAPI(
    String email,
    String password,
    String name,
    String store,
  ) async {
    try {
      if (repasswordNewC.text != passwordNewC.text) {
        snackbarNotif.unsuccess(
          'Re-password doesn`t match',
          'Masukkan re-password kembali',
        );

        repasswordNewC.clear();
        return;
      }

      if (password.length < 6) {
        snackbarNotif.unsuccess(
          'Week Password',
          'Masukkan minimal 6 digit password',
        );

        passwordNewC.clear();
        repasswordNewC.clear();
        return;
      }

      var passwordBase64 = base64Url.encode(utf8.encode(password));
      var response = await http.post(
        Uri.parse('$baseUrl/register/phone'),
        body: json.encode({
          'email': email,
          'name': name,
          'password': passwordBase64,
          'store': store,
          'plan': plan,
        }),
      );

      var data = jsonDecode(response.body);
      // Register Gagal
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );

        return;
      }

      // Register Success
      snackbarNotif.success(
        'Success',
        'Owner telah ditambahkan, Silakan Login.',
      );

      usernameNewC.clear();
      emailNewC.clear();
      storeNewC.clear();
      passwordNewC.clear();
      repasswordNewC.clear();
      return Get.toNamed(RouteName.loginMobile);
      //
    } catch (e) {
      print(e);
    }
  }
}
