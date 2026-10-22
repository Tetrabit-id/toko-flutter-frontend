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

  List<String> titles = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jum`at',
    'Sabtu',
    'Minggu',
  ];
  List<double> counter = [0, 1, 2, 3, 4, 5, 6];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Card(
          elevation: 0,
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 13, top: 5, bottom: 30),
                      child: Text(
                        'Ringkasan Penjualan',
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<Object>(
                          stream: getDataSummary.dataSummaryChart.stream,
                          builder: (context, snapshot) {
                            return BarChart(BarChartData(
                              titlesData: FlTitlesData(
                                rightTitles: AxisTitles(),
                                topTitles: AxisTitles(),
                                bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          return SideTitleWidget(
                                            axisSide: meta.axisSide,
                                            child: Text(
                                              titles[value.toInt()],
                                              style: const TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        })),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(
                                show: false,
                              ),
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: Colors.black87,
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) =>
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
                              maxY: getDataSummary.getNilaiSummaryHigh(),
                              minY: getDataSummary.getNilaiSummaryLow(),
                              groupsSpace: 2,
                              barGroups: widget.dataChart
                                  .map(
                                    (element) => BarChartGroupData(
                                      x: element['id'],
                                      barRods: [
                                        BarChartRodData(
                                            toY: element['data'],
                                            color: AppColors.primaryColor,
                                            width: 15,
                                            borderRadius:
                                                BorderRadius.circular(0))
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ));
                          }),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
