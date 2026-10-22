import 'package:flutter/material.dart';

import '../../../../routes/state_global.dart';
import '../../../../style/styles.dart';
import 'detail_card.dart';

class MonthlyIncomeCard extends StatelessWidget {
  const MonthlyIncomeCard({super.key, required this.dateNow});

  final String dateNow;

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      icon: Icons.trending_up_rounded,
      title: 'Pemasukan Bulan Ini',
      subtitle: labelBulan(dateNow),
      child: FutureBuilder<num>(
          future: transaksi.getPemasukanMonth(dateNow),
          initialData: transaksi.pendapatanBulanan,
          builder: (context, snapshot) {
            return FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(current.format(snapshot.data ?? 0),
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold)),
            );
          }),
    );
  }
}
