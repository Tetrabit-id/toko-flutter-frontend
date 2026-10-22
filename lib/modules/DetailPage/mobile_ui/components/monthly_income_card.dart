import 'package:flutter/material.dart';

import '../../../../routes/state_global.dart';
import '../../../../style/styles.dart';

class MonthlyIncomeCard extends StatelessWidget {
  const MonthlyIncomeCard({
    super.key,
    required this.querySize,
    required this.dateNow,
  });

  final MediaQueryData querySize;
  final String dateNow;

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.stacked_line_chart_rounded,
                        color: AppColors.primaryColor,
                        size: 15,
                      ),
                      SizedBox(width: 5),
                      Text('Pemasukan Bulan ini',
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Text(dateNow,
                      style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14,
                          fontWeight: FontWeight.w300))
                ],
              ),
              const SizedBox(height: 5),
              FutureBuilder<num>(
                  future: transaksi.getPemasukanMonth(dateNow),
                  initialData: transaksi.pendapatanBulanan,
                  builder: (context, snapshot) {
                    return Text(current.format(transaksi.pendapatanBulanan),
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
