import 'package:tetrabit_toko_pos/routes/app_binding.dart';
import 'package:tetrabit_toko_pos/routes/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Web doesn't read google-services.json, so it needs explicit options.
const webFirebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyAnRPttLk4NU8IapYvOkNA98qtuPfEu2ZY",
  authDomain: "toko-pos-2cda9.firebaseapp.com",
  projectId: "toko-pos-2cda9",
  storageBucket: "toko-pos-2cda9.firebasestorage.app",
  messagingSenderId: "806746640310",
  appId: "1:806746640310:web:63e7abc8c4544405e8fb17",
  measurementId: "G-SZGL63SL5Z",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: kIsWeb ? webFirebaseOptions : null);
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
