import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../components/chart_sales_summary.dart';
import '../../../routes/state_global.dart';
import '../../../style/styles.dart';

class SalesSummary extends StatelessWidget {
  const SalesSummary({
    Key? key,
    required this.size,
    required this.dataChart,
  }) : super(key: key);

  final Size size;
  final List dataChart;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: transaksi.getTransaksiDate7Ago(),
        initialData: transaksi.dataLaporan7Ago,
        builder: (context, snapshot) {
          List days = [
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday',
            'Sunday'
          ];
          List salesSummary = [
            {'id': 0, 'data': 0.0, 'day': '', 'tgl': ''},
            {'id': 1, 'data': 0.0, 'day': '', 'tgl': ''},
            {'id': 2, 'data': 0.0, 'day': '', 'tgl': ''},
            {'id': 3, 'data': 0.0, 'day': '', 'tgl': ''},
            {'id': 4, 'data': 0.0, 'day': '', 'tgl': ''},
            {'id': 5, 'data': 0.0, 'day': '', 'tgl': ''},
            {'id': 6, 'data': 0.0, 'day': '', 'tgl': ''}
          ];
          List data = snapshot.data ?? [];
          getDataSummary.dataSummaryChart.clear();
          if (data.isNotEmpty &&
              getDataSummary.dataSummaryChart != salesSummary) {
            getDataSummary.dataSummaryChart.addAll(salesSummary);

            for (var element in data.toList()) {
              for (int i = 0; i < element.length; i++) {
                getDataSummary.dataSummary.add({
                  'day': DateFormat('EEEE')
                      .format(DateTime.parse(element[i]['date'])),
                  'jumlah-transaksi': element[i]['jumlahTransaksi'],
                  'tgl': element[i]['date']
                });
              }
            }

            for (var i = 0; i < days.length; i++) {
              for (var element in getDataSummary.dataSummary
                  .where((e) => e['day'] == days[i])) {
                num current = element['jumlah-transaksi'];

                getDataSummary.dataSummaryChart[i]['data'] =
                    getDataSummary.dataSummaryChart[i]['data'] + current;

                getDataSummary.dataSummaryChart[i]['tgl'] = element['tgl'];
              }
              getDataSummary.dataSummaryChart[i]['day'] = days[i];
            }

            getDataSummary.dataSummary.clear();
            transaksi.dataLaporan7Ago.clear;

            return ChartSummary(size: size, dataChart: dataChart);
          }
          if (getDataSummary.dataSummaryChart == salesSummary) {
            return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                child: AspectRatio(
                    aspectRatio: 1.6,
                    child: Container(
                      color: Colors.white,
                      child: AppSvg.notFoundChartSvg,
                    )));
          }

          return getDataSummary.dataSummaryChart.isEmpty
              ? const SizedBox()
              : const AspectRatio(
                  aspectRatio: 1.8,
                  child: Center(
                      child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                    strokeWidth: 2,
                  )),
                );
        });
  }
}
