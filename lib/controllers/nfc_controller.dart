// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:typed_data';
// ignore: depend_on_referenced_packages
import 'package:convert/convert.dart';

import 'package:tetrabit_toko_pos/routes/state_global.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

class NfcController extends GetxController {
  NfcManager nfc = NfcManager.instance;
  late RxString dataNfc = ''.obs;

  Future<String> readNFC() async {
    final completer = Completer<String>();
    var isNfcAvalible = await nfc.isAvailable();

    if (!isNfcAvalible) {
      snackbarNotif.unsuccess('NFC Non-aktif', 'Mohon nyalakan perangkat NFC');
      return '';
    }

    snackbarNotif.success('NFC Aktif', 'Silakan tempelkan kartu');

    await nfc.startSession(onDiscovered: ((tag) async {
      var ndef = IsoDep.from(tag);

      if (ndef == null) {
        snackbarNotif.unsuccess('NFC Gagal', 'Mohon tempelkan kartu kembali');
        dataNfc.value = '';
        return completer.complete('');
      }

      try {
        Uint8List? data = ndef.identifier;
        String test = hex.encode(data);
        dataNfc.value = test;

        return completer.complete(dataNfc.value);
      } catch (e) {
        print(e);
      }
    }));

    return completer.future;
  }
}
