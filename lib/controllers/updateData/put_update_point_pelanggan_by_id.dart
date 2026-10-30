// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:tetrabit_toko_pos/routes/base_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/state_global.dart';

class UpdatePointPelangganAPI extends GetxController {
  Future<void> connectAPI(String idMember, int poin) async {
    // Paket offline: poin checkout sudah ditambah di localTransaksi.checkout
    if (paket.isOffline) {
      await localPelanggan.updatePoin(idMember, poin);
      return;
    }

    try {
      var response = await http.put(Uri.parse('$baseUrl/memberships/$idMember'),
          body: json.encode({
            'poin': poin,
          }),
          headers: {'Authorization': 'Bearer ${token.read('token')}'});

      var data = jsonDecode(response.body);

      // Update Point Gagal
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );

        return;
      }

      // Update Success
      Get.back();
      snackbarNotif.success('Success', '+100 Point telah ditambahkan');
      rekapKas.kasAkhirNewRekapC.clear();

      //
    } catch (e) {
      print(e);
    }
  }
}
