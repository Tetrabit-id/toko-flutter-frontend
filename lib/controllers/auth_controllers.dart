import 'dart:convert';

import 'package:diatera_pos/models/user_owner.dart';
import 'package:diatera_pos/routes/base_url.dart';
import 'package:diatera_pos/routes/route.dart';
import 'package:diatera_pos/routes/state_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth_google;
import 'package:http/http.dart' as http;

import '../components/edit_akun_popup.dart';
import '../models/user.dart';

class AuthController extends GetxController {
  List<bool> isSelected = [true, false];

  List<String> roles = ['Kasir', 'Gudang'];

  bool checkedSubU = false;
  final getData = List.empty().obs;
  final dataUser = List.empty().obs;

  // for Owner
  TextEditingController emailLogC = TextEditingController();
  TextEditingController passwordLogC = TextEditingController();
  bool checkedLogin = false;

  // for Owner by Google
  TextEditingController passwordEmptyC = TextEditingController();
  TextEditingController tokoEmptyC = TextEditingController();

  // for Owner Edit by PopUp
  TextEditingController editUsernameC = TextEditingController();
  TextEditingController editTokoC = TextEditingController();

  // for Karyawan
  TextEditingController emailKLogC = TextEditingController();
  TextEditingController passwordKLogC = TextEditingController();

  Owner? user;
  User? userByToken;

  // Tombol Fungsi Login by Google
  final auth_google.FirebaseAuth googleAuth = auth_google.FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Login for Owner
  Future loginOwner(String email, String password) async {
    user = await postApiLoginO.connectAPI(email, password);
    if (user?.token == null) {
      update();
      return;
    }

    if (user?.role != 'admin') {
      snackbarNotif.unsuccess(
        'Wrong auth role',
        'Sistem mendeteksi rolemu bukan owner. Silakan Login pada page Karyawan',
      );

      // clear field email & pw
      emailLogC.clear();
      passwordLogC.clear();
      checkedLogin = false;
      update();
      return;
    }
    // Insert ke Local Storage
    await token.write('token', user!.token);
    await token.write('_id', user!.id);
    await token.write('cabangId', user!.cabangId);
    await token.write('role', user!.role);
    await token.write('store', user!.store);
    await token.write('email', user!.email);
    await token.write('name', user!.name);
    await token.write('owner', user!.owner);
    update();

    // clear field email & pw
    emailLogC.clear();
    passwordLogC.clear();
    checkedLogin = false;

    Get.offAndToNamed(user!.statusPembayaran == false
        ? RouteName.paymentInfoForOwner
        : RouteName.index);
  } // end login

  // Login or Register for Owner by Google
  Future loginOwnerbyGoogle() async {
    user = await postApiLoginO.connectAPIbyGoogle();
    if (user?.token == null) {
      update();
      return;
    }

    // Insert ke Local Storage
    await token.write('token', user!.token);
    await token.write('_id', user!.id);
    await token.write('cabangId', user!.cabangId);
    await token.write('role', user!.role);
    await token.write('store', user!.store);
    await token.write('email', user!.email);
    await token.write('name', user!.name);
    await token.write('owner', user!.owner);
    update();

    if (user!.store!.isEmpty == true) {
      return Get.offAndToNamed(RouteName.firstAddToko);
    }

    Get.offAndToNamed(user!.statusPembayaran == false
        ? RouteName.paymentInfoForOwner
        : RouteName.index);
  } // end login

  //Login for karyawan
  Future loginKaryawan(String email, String password) async {
    userByToken = await postApiLoginK.connectAPI(email, password);
    if (userByToken?.token == null) {
      update();
      return;
    }

    // Insert ke Local Storage
    await token.write('token', userByToken!.token);
    await token.write('_id', userByToken!.id);
    await token.write('cabangId', userByToken!.cabangId);
    await token.write('role', userByToken!.role);
    await token.write('store', userByToken!.store);
    await token.write('email', userByToken!.email);
    await token.write('name', userByToken!.name);
    await token.write('parent', userByToken!.parent);
    await token.write('owner', userByToken!.owner);
    update();

    // clear field email & pw
    emailKLogC.clear();
    passwordKLogC.clear();
    checkedSubU = false;

    // cek status pembayaran by owner
    bool statusPembayaran = await checkPembayaranKaryawan.connectAPI(
      token.read('parent'),
      token.read('token'),
    );
    if (statusPembayaran == false) {
      return Get.offAndToNamed(RouteName.paymentInfoForKaryawan);
    }

    await getApiUsersK.getApi();
    List idOwner = getApiUsersK.dataUKaryawan;

    if (idOwner.isEmpty) {
      getApiUsersK.getApi();
      idOwner = getApiUsersK.dataUKaryawan;
    }

    await token.write('parentId', idOwner.first['_id']);

    return userByToken?.role == 'Kasir'
        ? Get.offAndToNamed(RouteName.indexKasir)
        : Get.offAndToNamed(RouteName.indexGudang);
  } // end login

  // Remember me and select page route
  autoLogin() async {
    if (token.hasData('token') == true) {
      userByToken = await checkApiToken.connectAPI(
        token.read('token'),
        token.read('_id'),
      );

      // AutoLog selain role admin
      if (userByToken?.role != 'admin') {
        bool statusPembayaran = await checkPembayaranKaryawan.connectAPI(
          userByToken?.parent,
          token.read('token'),
        );

        // cek status pembayaran by owner
        if (statusPembayaran == false) {
          return Get.offAndToNamed(RouteName.paymentInfoForKaryawan);
        }

        return userByToken?.role == 'Kasir'
            ? Get.offAndToNamed(RouteName.indexKasir)
            : Get.offAndToNamed(RouteName.indexGudang);
      }

      if (userByToken?.store!.isEmpty == true) {
        return Get.offAllNamed(RouteName.firstAddToko);
      }

      // AutoLog role admin
      return userByToken?.statusPembayaran == false
          ? Get.offAndToNamed(RouteName.paymentInfoForOwner)
          : Get.offAndToNamed(RouteName.index);
    }
  } // end autologin

  // Tombol untuk update pass google for basis & update nama toko
  Future<void> addEmptybyLoginGoogle(String toko, String pass) async {
    var responseToko = await http.put(
      Uri.parse('$baseUrl/users/${token.read('_id')}'),
      body: json.encode(
        {'store': toko},
      ),
      headers: {'Authorization': 'Bearer ${token.read('token')}'},
    );

    var data = jsonDecode(responseToko.body);
    // Connect Api update Toko Gagal

    if (responseToko.statusCode != 200) {
      snackbarNotif.unsuccess('Unsuccess ${responseToko.statusCode}',
          '${(data['message']).toString().capitalizeFirst}');
      return;
    }

    //Update Nama Toko Success, lanjut update password
    var passwordBase64 = base64Url.encode(utf8.encode(pass));
    var responsePass = await http.post(
      Uri.parse('$baseUrl/register/${token.read('_id')}'),
      body: json.encode({'password': passwordBase64}),
    );

    var dataPass = jsonDecode(responsePass.body);
    // Register Gagal
    if (responsePass.statusCode != 200) {
      snackbarNotif.unsuccess('Unsuccess ${responsePass.statusCode}',
          '${(dataPass['message']).toString().capitalizeFirst}');
      return;
    }

    // Register Success
    // check pembayaran role admin
    return userByToken?.statusPembayaran == false
        ? Get.offAndToNamed(RouteName.paymentInfoForOwner)
        : Get.offAndToNamed(RouteName.index);
  }

  // Tombol Logout
  void logout() async {
    await token.read('token');
    Get.defaultDialog(
      middleText: 'Yakin, keluar Toko?',
      title: 'Logout Akun',
      titlePadding: const EdgeInsets.only(top: 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      onConfirm: () async {
        //Penghapusan Storage Local
        token.remove('token');
        token.remove('_id');
        token.remove('cabangId');
        token.remove('role');
        token.remove('parent');
        token.remove('parentId');
        token.remove('store');
        token.remove('email');
        token.remove('name');
        token.remove('owner');

        // menuju ;
        Get.offAllNamed(RouteName.firstPageMobile);

        // Logout Google
        await googleSignIn.signOut();
        await googleAuth.signOut();
      },
      onCancel: () {
        Get.back();
      },
      textConfirm: 'Keluar',
      textCancel: 'Cancel',
      buttonColor: Colors.white,
      confirmTextColor: Colors.red,
      cancelTextColor: Colors.black45,
    );
  }

  // Tombol Menampilkan PopUp Edit Akun
  void editAkun() async {
    userByToken = await checkApiToken.connectAPI(
      token.read('token'),
      token.read('_id'),
    );

    // Input data to PopUpAkun
    editUsernameC.text = userByToken!.name.toString();
    editTokoC.text = userByToken!.store.toString();

    Get.defaultDialog(
      title: 'Edit Akun',
      titlePadding: const EdgeInsets.only(top: 20),
      content: const PopUpAkun(),
    );
  }

  @override
  void onInit() {
    checkedLogin = false;
    super.onInit();
  }
}
