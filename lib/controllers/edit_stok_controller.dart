import 'package:tetrabit_toko_pos/routes/base_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/edit_stok.dart';
import '../routes/state_global.dart';

class EditAddStok extends GetxController {
  final dataEditStok = List<EditStok>.empty().obs;

  late TextEditingController editNmBrgC = TextEditingController();
  late TextEditingController editKodeBrgC = TextEditingController();
  late TextEditingController editQtyC = TextEditingController();
  late TextEditingController editStnC = TextEditingController();
  late TextEditingController editHrgC = TextEditingController();
  late TextEditingController editHrgBeliC = TextEditingController();

  RxString editSatuan = ''.obs;

  void addEditStok(
    String? id,
    String? cabangId,
    String? produkId,
    String? kodeBarang,
    String? namaBarang,
    String? qty,
    String? satuan,
    String? hargaBarang,
    String? hargaBeli,
  ) {
    dataEditStok.add(EditStok(
      stokId: id,
      cabangId: cabangId,
      produkId: produkId,
      kodeBarang: kodeBarang,
      namaBarang: namaBarang,
      qty: qty,
      satuan: satuan,
      hargaBarang: hargaBarang,
      hargaBeli: hargaBeli,
    ));
  }

  Future<void> delete(String stokId, String produkId) async {
    await Get.defaultDialog(
      title: 'Delete Data',
      middleText: "Apakah kamu yakin menghapus data ini secara permanen?",
      titlePadding: const EdgeInsets.only(top: 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      textConfirm: "Delete",
      buttonColor: Colors.white,
      confirmTextColor: Colors.red,
      cancelTextColor: Colors.black45,
      onConfirm: () async {
        await deleteApiUpdateStok.connectAPI(stokId, produkId);

        // refresh data
        var idOwner = token.read('role') != 'admin'
            ? token.read('parentId')
            : token.read('_id');
        await getApiStok.getAPI(idOwner, token.read('cabangId'));
        // stok.foundStok.clear();
        // stok.foundStok = getApiStok.dataStok;
        // end
        Get.back();
        Get.back();
      },
      textCancel: "Cancel",
    );
    return;
  }
}
