import 'package:diatera_pos/modules/DetailPage/mobile_ui/components/income_per_pelanggan.dart';
import 'package:diatera_pos/modules/DetailPage/mobile_ui/components/income_per_product.dart';
import 'package:diatera_pos/routes/state_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'components/check_available_card.dart';
import 'components/history_payment_card.dart';
import 'components/monthly_income_card.dart';
import 'components/week_income_card.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String dateNow = DateFormat('y-MM').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final querySize = MediaQuery.of(context);
    return MediaQuery(
      data: querySize.copyWith(textScaleFactor: 0.81),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black87,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text('Detail Pendapatanmu',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
        ),
        body: FutureBuilder<List>(
            future: getApiTransaksi.getApi(),
            initialData: getApiTransaksi.dataLaporan,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                if (snapshot.connectionState == ConnectionState.done) {
                  var data = snapshot.data!;
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      child: ListView(children: [
                        HistoryPaymentCard(querySize: querySize, data: data),
                        const SizedBox(height: 20),
                        CheckAvailableCard(data: data, querySize: querySize),
                        const SizedBox(height: 20),
                        MonthlyIncomeCard(
                          querySize: querySize,
                          dateNow: dateNow,
                        ),
                        const SizedBox(height: 20),
                        IncomeProductCard(
                            querySize: querySize, dateNow: dateNow),
                        const SizedBox(height: 20),
                        WeekIncomeCard(querySize: querySize, dateNow: dateNow),
                        const SizedBox(height: 20),
                        IncomePelangganCard(
                            querySize: querySize, dateNow: dateNow),
                      ]));
                }
                return SizedBox(
                  width: querySize.size.width,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              return const Text('No Data');
            }),
      ),
    );
  }
}
