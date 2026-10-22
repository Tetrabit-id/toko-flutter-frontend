import 'package:diatera_pos/routes/state_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddRekapKas extends GetxController {
  var foundKas = List.empty().obs;
  var dataKas = List.empty().obs;

  late TextEditingController filterC = TextEditingController();
  late TextEditingController controllerFieldC = TextEditingController();
  late TextEditingController kasAwalNewRekapC = TextEditingController();
  late TextEditingController kasAkhirNewRekapC = TextEditingController();
  late int editKasAwalRekapC = 0;
  late String idRekapKas = '';
  late String cabangIdRekapC = '';

  Future<void> delete(String idRekapKas) async {
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
        Get.back();
        await deleteApiUpdateRekapKas.connectAPI(idRekapKas);
        await getApiRekapKas.getApi();
        // end
      },
      onCancel: () {
        return;
      },
      textCancel: "Cancel",
    );
    return;
  }

  @override
  void onInit() {
    kasAwalNewRekapC = TextEditingController();
    kasAkhirNewRekapC = TextEditingController();
    cabangIdRekapC = '';
    super.onInit();
  }

  @override
  void dispose() {
    kasAwalNewRekapC.dispose();
    kasAkhirNewRekapC.dispose();
    super.dispose();
  }
}
