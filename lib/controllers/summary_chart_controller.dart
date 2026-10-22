import 'package:get/get.dart';

class GetDataSummary extends GetxController {
  final dataSummary = List.empty().obs;
  final dataSummaryChart = List.empty().obs;

  double getNilaiSummaryHigh() {
    double maxNum = dataSummaryChart[0]['data'];
    for (var i = 0; i < dataSummaryChart.length; i++) {
      if (dataSummaryChart[i]['data'] > maxNum) {
        maxNum = dataSummaryChart[i]['data'];
      }
    }
    dataSummaryChart.refresh();
    return maxNum;
  }

  double getNilaiSummaryLow() {
    double minNum = dataSummaryChart[0]['data'];
    for (var i = 0; i < dataSummaryChart[0].length; i++) {
      if (dataSummaryChart[i]['data'] < minNum) {
        minNum = dataSummaryChart[i]['data'];
      }
    }
    dataSummaryChart.refresh();
    return minNum;
  }
}
