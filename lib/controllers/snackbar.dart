import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../style/styles.dart';

class Snackbar extends GetxController {
  void success(String? title, String? message) {
    Get.snackbar(
      title!,
      message!,
      colorText: Colors.white,
      backgroundColor: AppColors.primaryColor,
      margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  void unsuccess(String? title, String? message) {
    Get.snackbar(
      title!,
      message!,
      colorText: Colors.white,
      backgroundColor: Colors.redAccent,
      margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  void unsuccessWithButton(
    String? title,
    String? message,
    void Function()? route,
    String nameBtn,
  ) {
    Get.snackbar(
      title!,
      message!,
      duration: const Duration(seconds: 4),
      colorText: Colors.white,
      backgroundColor: Colors.redAccent,
      margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      mainButton: TextButton(
          onPressed: route,
          child: Text(nameBtn,
              style: const TextStyle(
                color: Colors.white,
              ))),
    );
  }
}
