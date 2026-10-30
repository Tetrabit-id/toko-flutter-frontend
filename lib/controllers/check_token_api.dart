// ignore_for_file: avoid_print

import 'dart:convert';

import '../models/user.dart';
import 'package:tetrabit_toko_pos/routes/route.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../routes/base_url.dart';

class CheckTokenAPI extends GetxController {
  Future<User?> connectAPI(String token, String userId) async {
    final box = GetStorage();
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      var data = jsonDecode(response.body);

      // Jika Success connect api
      if (response.statusCode == 200) {
        var userData = (data as Map<String, dynamic>)['data'];

        return User.fromJson(userData);
      }
      //

      // Jika gagal connect api
      if (response.statusCode == 404) {
        update();
      }
      //

      if (response.statusCode != 200 || response.statusCode != 404) {
        box.remove('token');
        Get.offAndToNamed(RouteName.loginMobile);

        return User();
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
