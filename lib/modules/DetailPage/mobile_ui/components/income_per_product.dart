import 'package:flutter/material.dart';

import '../../../../routes/state_global.dart';
import 'detail_card.dart';

// Pendapatan per produk bulan ini, 5 teratas
class IncomeProductCard extends StatelessWidget {
  const IncomeProductCard({super.key, required this.dateNow});

  // yyyy-MM
  final String dateNow;

  @override
  Widget build(BuildContext context) {
    var awal = DateTime.parse('$dateNow-01');
    // Hari ke-0 bulan berikutnya = hari terakhir bulan ini
    var akhir = DateTime(awal.year, awal.month + 1, 0);

    return DetailCard(
      icon: Icons.local_mall_rounded,
      title: 'Pendapatan Per Produk',
      subtitle: '5 produk terlaris · ${labelBulan(dateNow)}',
      child: FutureBuilder<List>(
          future: reportProduk.getApi(
            '$dateNow-01',
            akhir.toString().substring(0, 10),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingDetail();
            }
            var data = (snapshot.data ?? []).take(5).toList();
            if (data.isEmpty) {
              return const KosongDetail(
                icon: Icons.local_mall_outlined,
                text: 'Belum ada produk terjual bulan ini',
              );
            }

            num tertinggi = data.first['total'] ?? 0;
            return Column(
              children: [
                for (var i = 0; i < data.length; i++) ...[
                  if (i > 0) const SizedBox(height: 14),
                  BarisPeringkat(
                    leading: '${i + 1}',
                    nama: '${data[i]['name']}',
                    keterangan: '${data[i]['qty']} terjual',
                    nilai: data[i]['total'] ?? 0,
                    proporsi: tertinggi == 0
                        ? 0
                        : (data[i]['total'] ?? 0) / tertinggi,
                  ),
                ],
              ],
            );
          }),
    );
  }
}
