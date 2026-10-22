import 'package:flutter/material.dart';

import '../../../../routes/state_global.dart';
import '../../../../style/styles.dart';

class WeekIncomeCard extends StatelessWidget {
  const WeekIncomeCard({
    super.key,
    required this.querySize,
    required this.dateNow,
  });

  final MediaQueryData querySize;
  final String dateNow;

  @override
  Widget build(BuildContext context) {
    var dataOnWeek = getDataSummary.dataSummaryChart;
    return MediaQuery(
      data: querySize.copyWith(textScaleFactor: 0.81),
      child: Container(
        width: querySize.size.width,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 3, offset: Offset(0, 0))
          ],
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.stacked_bar_chart,
                        color: AppColors.primaryColor,
                        size: 15,
                      ),
                      SizedBox(width: 5),
                      Text('Pendapatan Per Minggu',
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Text('Senin - Minggu',
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14,
                          fontWeight: FontWeight.w300))
                ],
              ),
              ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.grey.shade400, height: 24),
                  itemCount: dataOnWeek.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            dataOnWeek[index]['tgl'] == ''
                                ? '${dataOnWeek[index]['day']}'
                                : '${dataOnWeek[index]['day']}, ${dataOnWeek[index]['tgl']}',
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 16,
                            )),
                        Text(current.format(dataOnWeek[index]['data']),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold))
                      ],
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
