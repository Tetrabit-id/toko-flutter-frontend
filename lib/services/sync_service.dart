// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../routes/base_url.dart';
import '../routes/state_global.dart';

// Paket subscription: kirim data yang dibuat saat offline ke server.
// Jalan saat app dibuka, saat koneksi kembali, dan tiap 1 menit jika ada antrean.
class SyncService extends GetxController {
  static const batchSize = 50;

  final pending = 0.obs;
  final syncing = false.obs;
  Timer? _timer;

  Future<void> refreshCount() async {
    if (paket.isOffline || !token.hasData('token')) {
      pending.value = 0;
      return;
    }
    pending.value = await localSync.countPending();
  }

  Future<void> trigger() async {
    if (paket.isOffline || syncing.value || !token.hasData('token')) return;

    syncing.value = true;
    var lanjut = false;
    try {
      await refreshCount();
      if (pending.value == 0 || !await koneksi.check()) return;

      var batch = await localSync.buildBatch(limit: batchSize);
      var response = await http.post(
        Uri.parse('$baseUrl/sync/transaksi'),
        body: json.encode(batch),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      // Gagal: data tetap di HP dan dicoba lagi nanti
      if (response.statusCode != 200) {
        print('sync gagal ${response.statusCode}: ${response.body}');
        return;
      }

      var result = (jsonDecode(response.body) as Map<String, dynamic>)['data'];
      List accepted = result['accepted'] ?? [];
      await localSync.applyResult(accepted, result['rejected'] ?? []);

      // Masih ada sisa antrean: lanjut batch berikutnya
      lanjut = accepted.isNotEmpty &&
          batch.values.any((list) => list.length == batchSize);

      // Ambil ulang data terbaru dari server ke cache
      await getApiStok.getAPI(token.read('_id'), token.read('cabangId'));
      await getApiPelanggan.getApi();
    } catch (e) {
      print(e);
    } finally {
      syncing.value = false;
      await refreshCount();
    }

    if (lanjut) trigger();
  }

  @override
  void onInit() {
    super.onInit();
    refreshCount();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (pending.value > 0) trigger();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
