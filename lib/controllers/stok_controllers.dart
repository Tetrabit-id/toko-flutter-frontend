import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/base_url.dart';
import '../routes/state_global.dart';

class StokController extends GetxController {
  var dataStok = List.empty().obs;
  var foundStok = List.empty().obs;
  var loading = false.obs;
  late List outStok = List.empty().obs;
  late List availableStok = List.empty().obs;
  late String kategoriIdPrdC = '';
  late String merkIdPrdC = '';

  late TextEditingController nmBrgC = TextEditingController();
  late TextEditingController kodeBrgC = TextEditingController();
  late TextEditingController qtyBrgC = TextEditingController();
  late TextEditingController satuanBrgC = TextEditingController();
  late TextEditingController hrgBrgC = TextEditingController();
  late TextEditingController hrgBeliBrgC = TextEditingController();

  // Kategori Produk Atribute
  late TextEditingController nmKPrdC = TextEditingController();
  late TextEditingController kodeKPrdC = TextEditingController();

  // Merk Produk Atribute
  late TextEditingController nmMPrdC = TextEditingController();
  late TextEditingController kodeMPrdC = TextEditingController();

  String validasiText = '';

  Future<List> getOutStok(String? id, String? idCabang) async {
    await getApiStok.getAPI(id, idCabang);
    outStok = getApiStok.dataStok.where((data) => (data['qty'] ?? 0) < 0).toList();
    return outStok;
  }

  Future<List> getAvailableStok(String? id, String? idCabang) async {
    await getApiStok.getAPI(id, idCabang);
    availableStok =
        getApiStok.dataStok.where((data) => (data['qty'] ?? 0) == 0).toList();
    return availableStok;
  }

  Future<void> addStok(
    String? kodeBrg,
    String? produkKategoriId,
    String? produkMerkId,
    String? name,
    String? qty,
    String? satuan,
    String? harga,
    String? file,
    String? hargaBeli,
  ) async {
    if (file == '') {
      snackbarNotif.unsuccessWithButton(
        "Photo Kosong",
        "Mohon masukkan photo ke dalam produk",
        () => Get.back(),
        'OK',
      );
      return;
    }

    if (kodeBrg != '' &&
        name != '' &&
        qty != '' &&
        satuan != '' &&
        harga != '' &&
        produkKategoriId != '' &&
        produkMerkId != '') {
      var idOwner = token.read('role') != 'admin'
          ? token.read('parentId')
          : token.read('_id');

      loading.value = true;
      await postApiInsertProduk.connectAPI(
        idOwner,
        token.read('cabangId'),
        produkKategoriId,
        produkMerkId,
        kodeBrg,
        name,
        int.parse(qty!),
        satuan,
        int.parse(harga!.replaceAll(',', '').substring(4)),
        file,
        int.parse(hargaBeli!.replaceAll(',', '').substring(4)),
      );
      loading.value = false;

      nmBrgC.clear();
      kodeBrgC.clear();
      qtyBrgC.clear();
      satuanBrgC.clear();
      hrgBrgC.clear();
      nmKPrdC.clear();
      kodeKPrdC.clear();
      nmMPrdC.clear();
      kodeMPrdC.clear();
      hrgBeliBrgC.clear();

      // end
    } else {
      snackbarNotif.unsuccessWithButton(
        "Data Kosong",
        "Mohon lakukan Periksa Data kembali",
        () => Get.back(),
        'OK',
      );
    }
  }
}
