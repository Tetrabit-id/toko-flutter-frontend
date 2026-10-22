import 'package:flutter/material.dart';

import '../../../../routes/state_global.dart';
import '../../../../style/styles.dart';

class HistoryPaymentCard extends StatelessWidget {
  const HistoryPaymentCard({
    super.key,
    required this.querySize,
    required this.data,
  });

  final MediaQueryData querySize;
  final List data;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: querySize.copyWith(textScaleFactor: 0.81),
      child: Container(
        width: querySize.size.width,
        margin: const EdgeInsets.only(top: 16, left: 2, right: 2, bottom: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 64, 223, 7),
              Color.fromARGB(255, 5, 135, 29)
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Total Pemasukanmu',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Lato',
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              Text(current.format(transaksi.totalPemasukkan),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: querySize.size.width,
                  height: 1,
                  color: Colors.white,
                ),
              ),
              const Text('Per tanggal',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Lato',
                    fontSize: 14,
                  )),
              const SizedBox(height: 5),
              Text(
                  data.isEmpty
                      ? 'Tidak Ada Data'
                      : '${data.last['date']} - ${data.first['date']}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
