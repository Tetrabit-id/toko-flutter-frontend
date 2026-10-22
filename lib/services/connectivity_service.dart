import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../routes/base_url.dart';
import '../routes/state_global.dart';

// Status koneksi untuk paket subscription (offline-first).
class ConnectivityService extends GetxController {
  final online = true.obs;
  StreamSubscription<List<ConnectivityResult>>? _sub;

  // Paket subscription sedang tidak terhubung ke server: pakai cache & antrean
  bool get terputus => !paket.isOffline && !online.value;

  bool _adaJaringan(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  // WiFi/data aktif belum tentu bisa ke server, jadi server dicoba langsung.
  // Respons apa pun (termasuk 404) berarti server terjangkau.
  Future<bool> check() async {
    if (!_adaJaringan(await Connectivity().checkConnectivity())) {
      return online.value = false;
    }
    try {
      await http.get(Uri.parse(baseUrl)).timeout(const Duration(seconds: 3));
      return online.value = true;
    } catch (_) {
      return online.value = false;
    }
  }

  // Untuk fitur yang wajib online (kelola stok, cabang, karyawan, dll)
  bool butuhInternet() {
    if (paket.isOffline || online.value) return false;
    snackbarNotif.unsuccess(
      'Tidak ada koneksi',
      'Fitur ini membutuhkan internet',
    );
    return true;
  }

  @override
  void onInit() {
    super.onInit();
    check();
    _sub = Connectivity().onConnectivityChanged.listen((results) async {
      if (!_adaJaringan(results)) {
        online.value = false;
        return;
      }
      // Koneksi kembali: kirim transaksi yang tertunda
      if (await check()) sinkron.trigger();
    });
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
