import 'package:flutter/material.dart';

import '../../../../routes/state_global.dart';
import 'detail_card.dart';

// Pendapatan per pelanggan (member) bulan ini, 5 teratas
class IncomePelangganCard extends StatelessWidget {
  const IncomePelangganCard({super.key, required this.dateNow});

  // yyyy-MM
  final String dateNow;

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      icon: Icons.people_alt_rounded,
      title: 'Pendapatan Per Pelanggan',
      subtitle: '5 pelanggan teratas · ${labelBulan(dateNow)}',
      child: FutureBuilder<List<Map<String, dynamic>>>(
          future: transaksi.getPendapatanPerPelanggan(dateNow),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingDetail();
            }
            var data = (snapshot.data ?? []).take(5).toList();
            if (data.isEmpty) {
              return const KosongDetail(
                icon: Icons.person_outline_rounded,
                text: 'Belum ada transaksi member bulan ini',
              );
            }

            num tertinggi = data.first['total'];
            return Column(
              children: [
                for (var i = 0; i < data.length; i++) ...[
                  if (i > 0) const SizedBox(height: 14),
                  BarisPeringkat(
                    leading: '${data[i]['name']}'.isEmpty
                        ? '?'
                        : '${data[i]['name']}'[0].toUpperCase(),
                    nama: '${data[i]['name']}',
                    keterangan: '${data[i]['jumlah']} transaksi'
                        '${data[i]['memberId'] == '' ? '' : ' · ${data[i]['memberId']}'}',
                    nilai: data[i]['total'],
                    proporsi: tertinggi == 0 ? 0 : data[i]['total'] / tertinggi,
                  ),
                ],
              ],
            );
          }),
    );
  }
}
