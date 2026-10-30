// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:tetrabit_toko_pos/routes/base_url.dart';
import 'package:tetrabit_toko_pos/routes/state_global.dart';
import 'package:http/http.dart' as http;

class InsertPesananAPI extends GetxController {
  Future<void> connectAPI(
    List dataPesanan,
    String? userId,
  ) async {
    List dataPesananMap = dataPesanan
        .map((e) => {
              'userId': e.userId,
              'noInvoice': e.noInv,
              'cabangId': e.cabangId,
              'stokId': e.stokId,
              'produkId': e.produkId,
              'code': e.kodeBarang,
              'name': e.namaBarang,
              'harga': e.hargaBarangStok,
              'qty': e.qtyPembelian,
              'total': e.totalHarga
            })
        .toList();

    try {
      var response = await http.post(
        Uri.parse('$baseUrl/pesanan/$userId/get-by-owner'),
        body: {'data': json.encode(dataPesananMap)},
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ${token.read('token')}'
        },
      );
      var data = jsonDecode(response.body);

      // Insert Pesanan Gagal
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );

        return;
      }

      // Insert Pesanan Success
      var noInv = (data as Map<String, dynamic>)['data'];
      kasir.noInv = noInv;
      snackbarNotif.success('Success', 'Pesanan telah dibayar');
    } catch (e) {
      print(e);
    }
  }
}
