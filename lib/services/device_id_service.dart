// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';

import '../routes/base_url.dart';

class DeviceIdService extends GetxController {
  String? _id;
  String? _name;

  // ID perangkat yang dipakai untuk mengikat lisensi offline.
  // Android: ANDROID_ID (tetap sama walau reinstall, selama signing key sama).
  // iOS: identifierForVendor.
  Future<String> getId() async {
    if (_id != null) return _id!;
    String? id;
    try {
      if (Platform.isAndroid) {
        id = await const AndroidId().getId();
      } else if (Platform.isIOS) {
        id = (await DeviceInfoPlugin().iosInfo).identifierForVendor;
      }
    } catch (e) {
      print(e);
    }

    // Cadangan jika platform tidak memberi ID: buat sekali lalu simpan.
    if (id == null || id.isEmpty) {
      id = token.read('deviceIdFallback');
      if (id == null) {
        final random = Random.secure();
        id = List.generate(16, (_) => random.nextInt(16).toRadixString(16))
            .join();
        await token.write('deviceIdFallback', id);
      }
    }
    return _id = id;
  }

  Future<String> getName() async {
    if (_name != null) return _name!;
    try {
      if (Platform.isAndroid) {
        var info = await DeviceInfoPlugin().androidInfo;
        return _name = '${info.brand} ${info.model}';
      }
      if (Platform.isIOS) {
        var info = await DeviceInfoPlugin().iosInfo;
        return _name = info.utsname.machine;
      }
    } catch (e) {
      print(e);
    }
    return _name = 'Unknown';
  }
}
