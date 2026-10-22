import 'package:flutter/material.dart';

import '../../../../style/styles.dart';

class IncomeProductCard extends StatelessWidget {
  const IncomeProductCard({
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
                      Text('Pendapatan Per Produk',
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: 60,
                alignment: Alignment.center,
                child: const Text(
                  'Fitur segera tiba!',
                  style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
