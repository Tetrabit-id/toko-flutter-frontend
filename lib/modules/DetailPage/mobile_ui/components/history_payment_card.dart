import 'package:flutter/material.dart';

import '../../../../routes/state_global.dart';
import '../../../../style/styles.dart';

class HistoryPaymentCard extends StatelessWidget {
  const HistoryPaymentCard({super.key, required this.data});

  final List data;

  // Urutan data server & lokal berbeda, jadi cari tanggal awal & akhir
  String get periode {
    if (data.isEmpty) return 'Belum ada transaksi';
    var tanggal = data.map((e) => '${e['date']}'.substring(0, 10)).toList()
      ..sort();
    return '${tanggal.first}  –  ${tanggal.last}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 64, 190, 20),
            Color.fromARGB(255, 5, 120, 29),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.account_balance_wallet_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Text('Total Pemasukanmu',
                  style: TextStyle(
                    color: Colors.white70,
                    fontFamily: 'Lato',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
          const SizedBox(height: 14),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(current.format(transaksi.totalPemasukkan),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                )),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today_rounded,
                    color: Colors.white, size: 14),
                const SizedBox(width: 6),
                Text(periode,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
