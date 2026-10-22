import 'package:flutter/material.dart';

import '../../../../components/pemesanan_card.dart';
import '../../../../constructors/text_style.dart';
import '../../../../routes/state_global.dart';
import '../../../../style/styles.dart';

class BodyOrderan extends StatefulWidget {
  const BodyOrderan({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<BodyOrderan> createState() => _BodyOrderanState();
}

class _BodyOrderanState extends State<BodyOrderan> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: kasir.dataKasir.stream,
        builder: (context, snapshot) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        width: widget.size.width,
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                        width: 150,
                        child: Text(
                          'Daftar Pembelian',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        )),
                    Expanded(
                      child: Container(
                        width: widget.size.width,
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: widget.size.height / 1.9,
                child: kasir.dataKasir.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AppSvg.notFoundOrderanSvg,
                            headerNotFound('Pembelian kosong'),
                            const SizedBox(height: 40),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: kasir.dataKasir.length,
                        itemBuilder: (context, index) =>
                            CardPemesananKasirPage(index: index),
                      ),
              ),
            ],
          );
        });
  }
}
