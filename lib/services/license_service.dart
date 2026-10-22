// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config/env.dart';
import '../models/license.dart';
import '../routes/base_url.dart';
import '../routes/route.dart';
import '../routes/state_global.dart';

// Public key Ed25519 dari backend, diatur di env/*.json.
// Aman ditanam di aplikasi; private key-nya hanya ada di server.
const licensePublicKey = Env.licensePublicKey;

class LicenseService extends GetxController {
  // Lisensi offline yang valid untuk perangkat ini, atau null.
  // Tidak butuh internet: cukup verifikasi signature dengan public key.
  Future<License?> getValidLicense() async {
    String? payloadB64 = token.read('licensePayload');
    String? signatureB64 = token.read('licenseSignature');
    if (payloadB64 == null || signatureB64 == null) return null;

    try {
      var payload = base64.decode(payloadB64);
      var valid = await Ed25519().verify(
        payload,
        signature: Signature(
          base64.decode(signatureB64),
          publicKey: SimplePublicKey(
            base64.decode(licensePublicKey),
            type: KeyPairType.ed25519,
          ),
        ),
      );
      if (!valid) return null;

      var license = License.fromJson(jsonDecode(utf8.decode(payload)));
      if (license.plan != 'offline') return null;
      if (license.deviceId != await deviceId.getId()) return null;

      return license;
    } catch (e) {
      print(e);
    }
    return null;
  }

  // Tukar kode aktivasi dengan lisensi bertanda tangan dari server.
  Future<bool> activate(String code) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/license/activate'),
        body: json.encode({
          'code': code.trim().toUpperCase(),
          'deviceId': await deviceId.getId(),
          'deviceName': await deviceId.getName(),
        }),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      // Aktivasi Gagal
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );
        return false;
      }

      var licenseData = (data as Map<String, dynamic>)['data'];
      await token.write('licensePayload', licenseData['payload']);
      await token.write('licenseSignature', licenseData['signature']);

      // Pastikan lisensi yang diterima benar-benar valid di perangkat ini
      if (await getValidLicense() == null) {
        remove();
        snackbarNotif.unsuccess(
          'Lisensi tidak valid',
          'Hubungi admin untuk pengecekan kode aktivasi',
        );
        return false;
      }

      // Aktivasi Success
      await token.write('plan', 'offline');
      return true;
    } catch (e) {
      print(e);
      snackbarNotif.unsuccess(
        'Tidak ada koneksi',
        'Aktivasi kode membutuhkan internet',
      );
    }
    return false;
  }

  // Dipanggil di background saat app dibuka. Jika lisensi sudah dicabut
  // (akun diaktivasi di HP lain), lisensi di HP ini dihapus.
  // Gagal koneksi diabaikan, karena paket offline memang boleh tanpa internet.
  Future<void> checkRevoked(License license) async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/license/status?licenseId=${license.licenseId}'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );
      if (response.statusCode != 200) return;

      var data = (jsonDecode(response.body) as Map<String, dynamic>)['data'];
      if (data['status'] != 'revoked') return;

      remove();
      auth.clearSession();
      Get.offAllNamed(RouteName.loginMobile);
      snackbarNotif.unsuccess(
        'Lisensi dicabut',
        'Akunmu sudah diaktivasi di perangkat lain',
      );
    } catch (e) {
      print(e);
    }
  }

  void remove() {
    token.remove('licensePayload');
    token.remove('licenseSignature');
  }
}
