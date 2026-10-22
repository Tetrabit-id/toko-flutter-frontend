import 'package:flutter/material.dart';

import '../routes/state_global.dart';
import '../style/styles.dart';

class PopUpInvoice extends StatelessWidget {
  const PopUpInvoice({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height / 2.5,
      child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 50, child: AppImages.logoIconic),
                  const Text(
                    'INVOICE',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Kasir : ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    payment.dataInvoice[0].namaKasir.toString(),
                    style: const TextStyle(fontSize: 14),
                  )
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Nomor : ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    payment.dataInvoice[0].noInvoice!.toUpperCase(),
                    style: const TextStyle(fontSize: 14),
                  )
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Tanggal Transaksi : ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    payment.dataInvoice[0].date!,
                    style: const TextStyle(fontSize: 14),
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 25,
                      child: Text(
                        'Kode Barang',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      )),
                  Expanded(
                      flex: 30,
                      child: Text(
                        'Nama Barang',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      )),
                  Expanded(
                      flex: 10,
                      child: Text(
                        'Qty',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      )),
                  Expanded(
                    flex: 30,
                    child: Text(
                      'Total Pembelian',
                      textAlign: TextAlign.end,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              ListView.separated(
                  separatorBuilder: (context, index) =>
                      const Divider(color: Colors.grey, height: 0),
                  shrinkWrap: true,
                  itemCount: payment.dataInvoice[0].idDataKasir![0].length,
                  itemBuilder: (context, index) {
                    var list = payment.dataInvoice[0].idDataKasir![0];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 25,
                              child: Text(
                                '${list[index]['code']}',
                                textAlign: TextAlign.start,
                                style: const TextStyle(fontSize: 14),
                              )),
                          Expanded(
                              flex: 30,
                              child: Text(
                                '${list[index]['name']}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14),
                              )),
                          Expanded(
                              flex: 10,
                              child: Text(
                                '${list[index]['qty']}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14),
                              )),
                          Expanded(
                            flex: 30,
                            child: Text(
                              current.format(list[index]['total']),
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Expanded(
                    flex: 60,
                    child: Text(
                      'Sub Transaksi',
                      textAlign: TextAlign.end,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                      flex: 40,
                      child: Text(
                        current
                            .format(payment.dataInvoice[0].subJumlahTransaksi),
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontSize: 14),
                      ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 60,
                    child: Text(
                      'Diskon [ ${payment.dataInvoice[0].discountUnit} ${payment.dataInvoice[0].discountName} ]',
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                      flex: 40,
                      child: Text(
                        current.format(payment.dataInvoice[0].discountAmount),
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontSize: 14),
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Container(
                    height: 1,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 212, 212, 212),
                    )),
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 60,
                    child: Text(
                      'Total Pembayaran',
                      textAlign: TextAlign.end,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                      flex: 40,
                      child: Text(
                        current.format(payment.dataInvoice[0].amountInvoice),
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontSize: 14),
                      ))
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Expanded(
                    flex: 60,
                    child: Text(
                      'Bayar',
                      textAlign: TextAlign.end,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                      flex: 40,
                      child: Text(
                        current.format(payment.dataInvoice[0].bayar),
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontSize: 14),
                      ))
                ],
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 60,
                    child: Text(
                      'Kembalian',
                      textAlign: TextAlign.end,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                      flex: 40,
                      child: Text(
                        current.format(payment.dataInvoice[0].kembalian),
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontSize: 14),
                      ))
                ],
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                label: const Text(
                  'Print',
                  style: TextStyle(fontSize: 14, fontFamily: 'Lato'),
                ),
                icon: const Icon(Icons.print_outlined, size: 16),
                onPressed: () => printer.printDataInvoice(payment.dataInvoice),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.primaryColor,
                    fixedSize: const Size(75, 0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    )),
              ),
            ])),
      ),
    );
  }
}
