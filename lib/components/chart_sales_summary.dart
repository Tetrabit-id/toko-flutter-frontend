import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../routes/state_global.dart';
import '../style/styles.dart';

class ChartSummary extends StatefulWidget {
  const ChartSummary({
    Key? key,
    required this.size,
    required this.dataChart,
  }) : super(key: key);

  final Size size;
  final List dataChart;

  @override
  State<ChartSummary> createState() => _ChartSummaryState();
}

class _ChartSummaryState extends State<ChartSummary> {
  @override
  void initState() {
    getDataSummary.dataSummaryChart.refresh();
    super.initState();
  }

  List<String> titles = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
  List<double> counter = [0, 1, 2, 3, 4, 5, 6];

  @override
  Widget build(BuildContext context) {
    // Semua 0: maxY tetap 1 agar bar latar tetap tampil
    var maxY = getDataSummary.getNilaiSummaryHigh();
    maxY = maxY <= 0 ? 1 : maxY * 1.15;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: AspectRatio(
        aspectRatio: 1.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.bar_chart_rounded,
                      color: AppColors.primaryColor, size: 22),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ringkasan Penjualan',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                        )),
                    Text('7 hari terakhir',
                        style: TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<Object>(
                  stream: getDataSummary.dataSummaryChart.stream,
                  builder: (context, snapshot) {
                    return BarChart(BarChartData(
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(),
                        rightTitles: const AxisTitles(),
                        topTitles: const AxisTitles(),
                        bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return SideTitleWidget(
                                    meta: meta,
                                    child: Text(
                                      titles[value.toInt()],
                                      style: const TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 12,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                })),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (_) => Colors.black87,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                              BarTooltipItem(
                            current.format(rod.toY),
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      alignment: BarChartAlignment.spaceAround,
                      maxY: maxY,
                      minY: 0,
                      barGroups: widget.dataChart
                          .map(
                            (element) => BarChartGroupData(
                              x: element['id'],
                              barRods: [
                                BarChartRodData(
                                  toY: element['data'],
                                  color: AppColors.primaryColor,
                                  width: 16,
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(6)),
                                  backDrawRodData: BackgroundBarChartRodData(
                                    show: true,
                                    toY: maxY,
                                    color: AppColors.bgGrey,
                                  ),
                                )
                              ],
                            ),
                          )
                          .toList(),
                    ));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
