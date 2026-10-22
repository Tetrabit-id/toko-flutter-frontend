// ignore_for_file: avoid_print
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  ImagePicker imgPicker = ImagePicker();

  XFile? image;
  RxString? imagePath = ''.obs;

  Future<void> imagePickerByGallery() async {
    try {
      final XFile? img = await imgPicker.pickImage(source: ImageSource.gallery);

      if (img == null) return;
      imagePath!.value = img.path;
    } catch (e) {
      print(e);
    }
  }

  Future<void> imagePickerByCamera() async {
    try {
      final XFile? img = await imgPicker.pickImage(source: ImageSource.camera);

      if (img == null) return;
      imagePath!.value = img.path;
    } catch (e) {
      print(e);
    }
  }
}
