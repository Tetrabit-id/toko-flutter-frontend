import 'package:diatera_pos/routes/app_binding.dart';
import 'package:diatera_pos/routes/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Toko',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      initialRoute: RouteName.start,
      getPages: AppPages.pages,
    );
  }
}
