import 'package:diatera_pos/routes/state_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPelanggan extends GetxController {
  var foundPelanggan = List.empty().obs;
  var dataPelanggan = List.empty().obs;

  late TextEditingController filterC = TextEditingController();
  late TextEditingController controllerFieldC = TextEditingController();
  late TextEditingController nameNewPlgnC = TextEditingController();
  late TextEditingController nikNewPlgnC = TextEditingController();
  late TextEditingController emailNewPlgnC = TextEditingController();
  late TextEditingController phoneNewPlgnC = TextEditingController();
  late TextEditingController addressNewPlgnC = TextEditingController();
  late String cabangIdPlgnC = '';

  bool cabangPusat = false;
  RxBool foundPelangganId = false.obs;
  List<bool> isSelected = [true, false];

  Future<void> delete(String idPelanggan) async {
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
        await deleteApiUpdatePelanggan.connectAPI(idPelanggan);
        await getApiPelanggan.getApi();
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
    nameNewPlgnC = TextEditingController();
    emailNewPlgnC = TextEditingController();
    phoneNewPlgnC = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    nameNewPlgnC.dispose();
    emailNewPlgnC.dispose();
    phoneNewPlgnC.dispose();
    super.dispose();
  }
}
