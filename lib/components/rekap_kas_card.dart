import 'package:tetrabit_toko_pos/components/edit_rekap_kas_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/base_url.dart';
import '../routes/state_global.dart';
import '../style/styles.dart';

class RekapKasCard extends StatelessWidget {
  const RekapKasCard({Key? key, this.index = 0}) : super(key: key);
  final int index;

  Future<void> tutupBuku(int i) async {
    await token.read('_id');
    rekapKas.editKasAwalRekapC = 0;
    rekapKas.idRekapKas = '';
    var list = rekapKas.foundKas[i];
    rekapKas.idRekapKas = list['_id'];
    rekapKas.editKasAwalRekapC = list['kasAwal'];
    return Get.defaultDialog(
      title: 'Tutup Buku',
      titlePadding: const EdgeInsets.only(top: 20),
      content: const PopUpRekapKas(),
    );
  }

  @override
  Container build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: Responsive.isMobile(context) ? size.height / 8 : size.height / 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 25,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        const Text('Kas Awal',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            )),
                        Text(
                            current.format(rekapKas.foundKas[index]['kasAwal']),
                            style: const TextStyle(
                              fontSize: 18,
                            ))
                      ],
                    ),
                  )),
              const SizedBox(width: 10),
              Expanded(
                  flex: 25,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        const Text('Kas Akhir',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            )),
                        Text(
                            current
                                .format(rekapKas.foundKas[index]['kasAkhir']),
                            style: const TextStyle(
                              fontSize: 18,
                            ))
                      ],
                    ),
                  )),
              const SizedBox(width: 10),
              Expanded(
                  flex: 25,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        const Text('Selisih',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            )),
                        Text(
                            current.format(rekapKas.foundKas[index]['selisih']),
                            style: const TextStyle(
                              fontSize: 18,
                            ))
                      ],
                    ),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 65,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => tutupBuku(index),
                      child: const Text('Tutup Buku'))),
              const SizedBox(width: 10),
              Expanded(
                flex: 15,
                child: GestureDetector(
                    onTap: () => rekapKas
                        .delete(rekapKas.foundKas[index]['_id'].toString()),
                    child: const Icon(
                      Icons.delete_rounded,
                      size: 18,
                    )),
              ),
              const SizedBox(width: 10),
              Container(
                width: 1,
                height: 40,
                color: AppColors.borderColor,
              ),
              Expanded(
                flex: 15,
                child: GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
