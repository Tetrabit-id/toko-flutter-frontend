import 'package:diatera_pos/style/styles.dart';
import 'package:flutter/material.dart';

import '../routes/state_global.dart';

class LaporanCard extends StatefulWidget {
  const LaporanCard({Key? key, this.index = 0, required this.dataInvoice})
      : super(key: key);

  final int index;
  final List dataInvoice;

  @override
  State<LaporanCard> createState() => _LaporanCardState();
}

class _LaporanCardState extends State<LaporanCard> {
  @override
  GestureDetector build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => payment.laporanCard(widget.index, widget.dataInvoice, size),
      child: Container(
        width: size.width,
        height: 95,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
        child: Row(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Container(
                    //   width: 40,
                    //   height: 40,
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(20),
                    //       image: DecorationImage(
                    //         image: Image.asset(
                    //           'assets/img/logo_toko.png',
                    //           fit: BoxFit.cover,
                    //         ).image,
                    //       )),
                    // ),
                    // const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Created by',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          widget.dataInvoice[widget.index]['name'] ?? '',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ],
                ),
                Text(
                  dateFormat(widget.dataInvoice[widget.index]['date']),
                  style:
                      const TextStyle(color: Colors.white, fontFamily: 'Lato'),
                )
              ],
            )),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: size.width / 2.5,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    '#${(widget.dataInvoice[widget.index]['noInvoice']).toString().toUpperCase()}',
                    style: TextStyle(
                        color: Colors.blueGrey.shade400,
                        fontFamily: 'Lato',
                        fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Invoice Amount',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      current.format(
                          widget.dataInvoice[widget.index]['jumlahTransaksi']),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
