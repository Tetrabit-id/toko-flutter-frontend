import 'dart:convert';

import 'package:tetrabit_toko_pos/models/user_owner.dart';
import 'package:tetrabit_toko_pos/routes/base_url.dart';
import 'package:tetrabit_toko_pos/routes/route.dart';
import 'package:tetrabit_toko_pos/routes/state_global.dart';
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
    await token.write('plan', user!.plan);
    update();

    // clear field email & pw
    emailLogC.clear();
    passwordLogC.clear();
    checkedLogin = false;

    routeOwner(user!.plan, user!.statusPembayaran);
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
    await token.write('plan', user!.plan);
    update();

    if (user!.store!.isEmpty == true) {
      return Get.offAndToNamed(RouteName.firstAddToko);
    }

    routeOwner(user!.plan, user!.statusPembayaran);
  } // end login

  //Login for karyawan
  Future loginKaryawan(String email, String password) async {
    userByToken = await postApiLoginK.connectAPI(email, password);
    if (userByToken?.token == null) {
      update();
      return;
    }

    // Paket offline tidak punya karyawan
    if (userByToken?.plan == 'offline') {
      snackbarNotif.unsuccess(
        'Login karyawan tidak tersedia',
        'Toko ini memakai paket offline, silakan login sebagai owner',
      );
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
    // Paket offline: lisensi valid milik akun ini cukup untuk masuk tanpa internet
    if (token.hasData('token') == true) {
      var license = await lisensi.getValidLicense();
      if (license != null && license.userId == token.read('_id')) {
        await token.write('plan', 'offline');
        lisensi.checkRevoked(license);
        return Get.offAllNamed(RouteName.index);
      }
    }

    if (token.hasData('token') == true) {
      // Subscription tanpa koneksi: masuk dengan sesi terakhir, kasir tetap
      // jalan dan transaksi dikirim saat online
      if (token.read('plan') != 'offline' && !await koneksi.check()) {
        sinkron.refreshCount();
        var role = token.read('role');
        return Get.offAllNamed(role == 'admin'
            ? RouteName.index
            : role == 'Kasir'
                ? RouteName.indexKasir
                : RouteName.indexGudang);
      }

      userByToken = await checkApiToken.connectAPI(
        token.read('token'),
        token.read('_id'),
      );
      if (userByToken?.plan != null) {
        await token.write('plan', userByToken!.plan);
      }
      sinkron.trigger();

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
      return routeOwner(userByToken?.plan, userByToken?.statusPembayaran);
    }
  } // end autologin

  // Tujuan owner setelah login sesuai paket
  Future routeOwner(String? plan, bool? statusPembayaran) async {
    // Offline: aktif jika HP ini punya lisensi valid milik akun ini
    if (plan == 'offline') {
      var license = await lisensi.getValidLicense();
      return Get.offAllNamed(
          license != null && license.userId == token.read('_id')
              ? RouteName.index
              : RouteName.aktivasi);
    }

    // Subscription: aktif jika sudah dikonfirmasi admin
    return Get.offAndToNamed(statusPembayaran == false
        ? RouteName.paymentInfoForOwner
        : RouteName.index);
  }

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
    return routeOwner(token.read('plan'),
        userByToken?.statusPembayaran ?? user?.statusPembayaran);
  }

  //Penghapusan Storage Local
  // Lisensi offline sengaja tidak dihapus, agar login ulang di HP yang sama
  // tidak perlu kode aktivasi baru.
  void clearSession() {
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
    token.remove('plan');
  }

  // Tombol Logout
  void logout() async {
    await token.read('token');
    await sinkron.refreshCount();
    Get.defaultDialog(
      middleText: sinkron.pending.value > 0
          ? 'Masih ada ${sinkron.pending.value} data yang belum terkirim. Data tetap tersimpan di HP ini dan dikirim saat kamu login lagi.\n\nYakin, keluar Toko?'
          : 'Yakin, keluar Toko?',
      title: 'Logout Akun',
      titlePadding: const EdgeInsets.only(top: 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      onConfirm: () async {
        clearSession();

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
    if (paket.isOffline) {
      // Paket offline: isi dari sesi lokal, tidak perlu internet
      editUsernameC.text = token.read('name') ?? '';
      editTokoC.text = token.read('store') ?? '';
    } else {
      userByToken = await checkApiToken.connectAPI(
        token.read('token'),
        token.read('_id'),
      );

      // Input data to PopUpAkun
      editUsernameC.text = userByToken!.name.toString();
      editTokoC.text = userByToken!.store.toString();
    }

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
