import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../routes/state_global.dart';
import '../style/styles.dart';

// Menunggu pelanggan menyelesaikan pembayaran Midtrans.
// Status dicek ke server tiap 3 detik (server menerima notifikasi Midtrans).
// Ditutup dengan hasil true jika lunas, false jika gagal / dibatalkan.
class PopUpMidtransWait extends StatefulWidget {
  const PopUpMidtransWait({
    super.key,
    required this.orderId,
    required this.redirectUrl,
    required this.amount,
  });

  final String orderId;
  final String redirectUrl;
  final num amount;

  @override
  State<PopUpMidtransWait> createState() => _PopUpMidtransWaitState();
}

class _PopUpMidtransWaitState extends State<PopUpMidtransWait> {
  Timer? _timer;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _cekStatus());
  }

  Future<void> _cekStatus() async {
    if (_checking) return;
    _checking = true;
    var status = await midtrans.status(widget.orderId);
    _checking = false;
    if (!mounted) return;

    if (status == 'paid') {
      _timer?.cancel();
      Get.back(result: true);
    } else if (status == 'failed') {
      _timer?.cancel();
      Get.back(result: false);
      snackbarNotif.unsuccess(
          'Pembayaran gagal', 'Pembayaran dibatalkan atau kadaluarsa');
    }
  }

  void _bukaHalamanBayar() => launchUrl(Uri.parse(widget.redirectUrl),
      mode: LaunchMode.inAppBrowserView);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Menunggu Pembayaran', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(current.format(widget.amount),
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Lato')),
            const SizedBox(height: 15),
            const CircularProgressIndicator(color: AppColors.primaryColor),
            const SizedBox(height: 15),
            const Text(
              'Selesaikan pembayaran QRIS / VA / e-wallet. Halaman ini otomatis tertutup setelah pembayaran diterima.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () {
              _timer?.cancel();
              Get.back(result: false);
            },
            child: const Text('Batal', style: TextStyle(color: Colors.black45)),
          ),
          TextButton(
            onPressed: _bukaHalamanBayar,
            child: const Text('Buka Halaman Bayar',
                style: TextStyle(color: AppColors.primaryColor)),
          ),
        ],
      ),
    );
  }
}
