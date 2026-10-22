import 'package:flutter/material.dart';

import '../../../../routes/base_url.dart';
import '../../../../routes/state_global.dart';

class CheckAvailableCard extends StatelessWidget {
  const CheckAvailableCard({
    super.key,
    required this.data,
    required this.querySize,
  });

  final List data;
  final MediaQueryData querySize;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: querySize.copyWith(textScaler: const TextScaler.linear(0.81)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          transaksiBerhasilCard(),
          stokHabisCard(),
          stokTersediaCard(),
        ],
      ),
    );
  }

  Container stokTersediaCard() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 64, 223, 7),
            Color.fromARGB(255, 5, 135, 29)
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: FutureBuilder<List>(
        future:
            stok.getAvailableStok(token.read('_id'), token.read('cabangId')),
        initialData: stok.availableStok,
        builder: (context, snapshot) {
          var dataStokAv = stok.availableStok;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(dataStokAv.isEmpty ? '0' : dataStokAv.length.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              const Text('Stok Tersedia',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Lato',
                    fontSize: 12,
                  )),
            ],
          );
        },
      ),
    );
  }

  Container stokHabisCard() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 250, 54, 119),
            Color.fromARGB(255, 252, 78, 78)
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: FutureBuilder<List?>(
        future: stok.getOutStok(token.read('_id'), token.read('cabangId')),
        initialData: stok.outStok,
        builder: (context, snapshot) {
          var dataStok = stok.outStok;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(dataStok.isEmpty ? '0' : dataStok.length.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              const Text('Stok Habis',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Lato',
                    fontSize: 12,
                  )),
            ],
          );
        },
      ),
    );
  }

  Container transaksiBerhasilCard() {
    return Container(
        width: 80,
        height: 80,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 7, 133, 223),
              Color.fromARGB(255, 16, 195, 235)
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(data.isEmpty ? '0' : data.length.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            const Text('Transaksi Berhasil',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Lato',
                  fontSize: 12,
                )),
          ],
        ));
  }
}
