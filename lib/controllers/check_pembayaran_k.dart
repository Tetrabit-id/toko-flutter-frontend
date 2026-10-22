// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../routes/base_url.dart';
import '../routes/route.dart';

class CheckPembayaranKaryawanAPI extends GetxController {
  bool statusPembayaran = false;
  Future<bool> connectAPI(String? parentId, String token) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/users/$parentId/check-pembayaran'),
        body: json.encode({'email': parentId}),
        headers: {'Authorization': 'Bearer $token'},
      );

      var data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        Get.offAndToNamed(RouteName.loginMobile);
        return statusPembayaran;
      }

      var userData = (data as Map<String, dynamic>)['data'];
      return statusPembayaran = userData['statusPembayaran'];
    } catch (e) {
      print(e);
    }
    return statusPembayaran;
  }
}
