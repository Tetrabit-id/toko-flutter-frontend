import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddKasbon extends GetxController {
  var foundKasbon = List.empty().obs;
  var dataKasbon = List.empty().obs;

  late TextEditingController filterC = TextEditingController();
  late TextEditingController controllerFieldC = TextEditingController();
  RxBool kasbonActive = false.obs;

  // Future<void> delete(String idKasbon) async {
  //   await Get.defaultDialog(
  //     title: 'Delete Data',
  //     middleText: "Apakah kamu yakin menghapus data ini secara permanen?",
  //     titlePadding: const EdgeInsets.only(top: 15),
  //     contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
  //     textConfirm: "Delete",
  //     buttonColor: Colors.white,
  //     confirmTextColor: Colors.red,
  //     cancelTextColor: Colors.black45,
  //     onConfirm: () async {
  //       Get.back();
  //       await deleteApiUpdateRekapKas.connectAPI(idRekapKas);
  //       await getApiRekapKas.getApi();
  //       // end
  //     },
  //     onCancel: () {
  //       return;
  //     },
  //     textCancel: "Cancel",
  //   );
  //   return;
  // }
}
