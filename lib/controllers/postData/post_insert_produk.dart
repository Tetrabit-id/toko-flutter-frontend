// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:tetrabit_toko_pos/routes/base_url.dart';
import 'package:tetrabit_toko_pos/routes/state_global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertProdukAPI extends GetxController {
  // fungsi insert katagori produk
  Future<void> connectAPI(
    String? userId,
    String? cabangId,
    String? produkKategoriId,
    String? produkMerkId,
    String? kodeBarang,
    String? namaBarang,
    int qty,
    String? satuan,
    int hargaBarang,
    String? file,
    int hargaBeli,
  ) async {
    // Paket offline: produk + stok disimpan lokal, foto disalin ke folder app
    if (paket.isOffline) {
      var error = await localStok.insertProduk(
        produkKategoriId: produkKategoriId,
        produkMerkId: produkMerkId,
        code: kodeBarang ?? '',
        name: namaBarang ?? '',
        qty: qty,
        satuan: satuan,
        harga: hargaBarang,
        hargaModal: hargaBeli,
        file: file,
      );
      if (error != null) {
        snackbarNotif.unsuccess('Unsuccess', error);
        return;
      }
      snackbarNotif.success('Success', 'Produk telah ditambahkan');
      return;
    }
    if (koneksi.butuhInternet()) return;

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/produk/$userId/get-by-owner/insert'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer ${token.read('token')}',
        'Content-Type': 'multipart/form-data'
      });

      var dataImg = http.MultipartFile(
        'file',
        File(file!).readAsBytes().asStream(),
        File(file).lengthSync(),
        filename: file.split('/').last,
      );

      var produk = json.encode({
        'userId': userId,
        'code': kodeBarang,
        'name': namaBarang,
      });

      request.files.add(dataImg);
      request.fields['data'] = produk;

      var response = await request.send();
      var result = await http.Response.fromStream(response);
      var data = jsonDecode(result.body);

      // Insert Produk Gagal
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );
        return;
      }

      // Insert Produk Success
      var produkData = (data as Map<String, dynamic>)['data'];
      postApiInsertStok.connectAPI(
        userId,
        cabangId,
        produkData['_id'],
        produkKategoriId,
        produkMerkId,
        namaBarang,
        produkData['code'],
        qty,
        satuan,
        hargaBarang,
        hargaBeli,
      );
      //
    } catch (e) {
      print(e);
    }
  }
}
