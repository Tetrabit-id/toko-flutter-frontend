import 'package:tetrabit_toko_pos/models/cabang.dart';
import 'package:tetrabit_toko_pos/routes/state_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddKaryawan extends GetxController {
  var foundUser = List.empty().obs;

  late TextEditingController nameNewKryC = TextEditingController();
  late TextEditingController emailNewKryC = TextEditingController();
  late TextEditingController pwNewKryC = TextEditingController();
  late String cabangIdKryC = '';
  late Cabang? cabangC = Cabang(id: '');

  late String role = 'Kasir';
  bool cabangPusat = false;
  List<bool> isSelected = [true, false];
  List<String> roles = ['Kasir', 'Gudang'];

  Future<void> delete(String idKaryawan) async {
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
        await deleteApiUpdateKaryawan.connectAPI(idKaryawan);
        await getApiUsersK.getApi();
        // end
      },
      onCancel: () => Get.back(),
      textCancel: "Cancel",
    );
    return;
  }

  @override
  void onInit() {
    role = 'Kasir';
    nameNewKryC = TextEditingController();
    emailNewKryC = TextEditingController();
    pwNewKryC = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    nameNewKryC.dispose();
    emailNewKryC.dispose();
    pwNewKryC.dispose();
    super.dispose();
  }
}
