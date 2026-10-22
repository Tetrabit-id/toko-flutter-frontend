// ignore_for_file: avoid_print
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  ImagePicker imgPicker = ImagePicker();

  XFile? image;
  RxString? imagePath = ''.obs;

  Future<void> imagePickerByGallery() async {
    try {
      final XFile? img = await imgPicker.pickImage(
        source: ImageSource.gallery,
        // Web: foto disimpan sebagai data URI di DB lokal, jadi diperkecil
        maxWidth: kIsWeb ? 1024 : null,
        imageQuality: kIsWeb ? 80 : null,
      );

      if (img == null) return;
      image = img;
      imagePath!.value = img.path;
    } catch (e) {
      print(e);
    }
  }

  Future<void> imagePickerByCamera() async {
    try {
      final XFile? img = await imgPicker.pickImage(
        source: ImageSource.camera,
        // Web: foto disimpan sebagai data URI di DB lokal, jadi diperkecil
        maxWidth: kIsWeb ? 1024 : null,
        imageQuality: kIsWeb ? 80 : null,
      );

      if (img == null) return;
      image = img;
      imagePath!.value = img.path;
    } catch (e) {
      print(e);
    }
  }
}
