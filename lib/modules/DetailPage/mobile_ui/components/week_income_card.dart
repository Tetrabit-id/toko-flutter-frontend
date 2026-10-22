import 'package:flutter/material.dart';

import '../../../../routes/state_global.dart';
import '../../../../style/styles.dart';
import 'detail_card.dart';

const _hari = {
  'Monday': 'Senin',
  'Tuesday': 'Selasa',
  'Wednesday': 'Rabu',
  'Thursday': 'Kamis',
  'Friday': 'Jumat',
  'Saturday': 'Sabtu',
  'Sunday': 'Minggu',
};

class WeekIncomeCard extends StatelessWidget {
  const WeekIncomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    var dataOnWeek = getDataSummary.dataSummaryChart;
    num tertinggi = dataOnWeek.fold<num>(
        0, (a, e) => (e['data'] as num) > a ? e['data'] : a);

    return DetailCard(
      icon: Icons.date_range_rounded,
      title: 'Pendapatan Per Hari',
      subtitle: '7 hari terakhir',
      child: dataOnWeek.isEmpty
          ? const KosongDetail(
              icon: Icons.event_busy_rounded,
              text: 'Belum ada data minggu ini',
            )
          : Column(
              children: [
                for (var i = 0; i < dataOnWeek.length; i++) ...[
                  if (i > 0) const SizedBox(height: 12),
                  _BarisHari(
                    hari: _hari[dataOnWeek[i]['day']] ??
                        '${dataOnWeek[i]['day']}',
                    tanggal: '${dataOnWeek[i]['tgl']}',
                    nilai: dataOnWeek[i]['data'],
                    proporsi:
                        tertinggi == 0 ? 0 : dataOnWeek[i]['data'] / tertinggi,
                  ),
                ],
              ],
            ),
    );
  }
}

class _BarisHari extends StatelessWidget {
  const _BarisHari({
    required this.hari,
    required this.tanggal,
    required this.nilai,
    required this.proporsi,
  });

  final String hari;
  final String tanggal;
  final num nilai;
  final double proporsi;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(hari,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              if (tanggal.length >= 10)
                Text(tanggal.substring(0, 10),
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: proporsi.clamp(0, 1),
              minHeight: 8,
              backgroundColor: AppColors.bgGrey,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: Text(current.format(nilai),
              textAlign: TextAlign.end,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
