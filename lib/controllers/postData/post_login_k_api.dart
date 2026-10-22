// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:diatera_pos/models/user.dart';
import 'package:diatera_pos/routes/state_global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:diatera_pos/routes/base_url.dart';

class DataLoginKaryawanAPI extends GetxController {
  // Tombol Fungsi Login
  Future<User?> connectAPI(String email, String password) async {
    var token = base64Url.encode(utf8.encode('$email:$password'));
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: json.encode({}),
        headers: {'Authorization': 'Basic $token'},
      );

      var data = jsonDecode(response.body);

      // Jika gagal connect api
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess('Unsuccess ${response.statusCode}',
            '${(data['message']).toString().capitalizeFirst}');

        return User();
      }
      //

      // Jika Success connect api
      var userData = (data as Map<String, dynamic>)['data'];

      return User.fromJson(userData);
      //
    } catch (e) {
      print(e);
    }
    return null;
  }
}
