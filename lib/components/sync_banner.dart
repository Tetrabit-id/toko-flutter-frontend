import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/state_global.dart';
import '../style/styles.dart';

// Paket subscription: status koneksi & data yang belum terkirim ke server.
// Ketuk untuk mengirim sekarang.
class SyncBanner extends StatelessWidget {
  const SyncBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var offline = !koneksi.online.value;
      var pending = sinkron.pending.value;
      if (paket.isOffline || (!offline && pending == 0)) {
        return const SizedBox.shrink();
      }

      String text;
      if (offline) {
        text = pending > 0
            ? 'Offline · $pending data belum terkirim'
            : 'Offline · transaksi disimpan di HP';
      } else if (sinkron.syncing.value) {
        text = 'Mengirim $pending data...';
      } else {
        text = '$pending data belum terkirim · ketuk untuk kirim';
      }

      return GestureDetector(
        onTap: () => sinkron.trigger(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          color: offline ? Colors.orange.shade700 : AppColors.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(offline ? Icons.cloud_off : Icons.cloud_upload,
                  size: 16, color: Colors.white),
              const SizedBox(width: 6),
              Text(text,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 13, fontFamily: 'Lato')),
            ],
          ),
        ),
      );
    });
  }
}
