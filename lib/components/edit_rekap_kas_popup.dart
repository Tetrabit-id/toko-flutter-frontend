import 'package:flutter/material.dart';

import '../constructors/text_field_rounded.dart';
import '../routes/state_global.dart';
import '../style/styles.dart';

class PopUpRekapKas extends StatelessWidget {
  const PopUpRekapKas({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 5),
          textFieldRoundedCurrentwithHint(
              'Kas Akhir',
              rekapKas.kasAkhirNewRekapC,
              false,
              TextInputType.number,
              'Rp.',
              TextAlign.start,
              size),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              int selisih = int.parse(rekapKas.kasAkhirNewRekapC.text
                      .substring(4)
                      .replaceAll(',', '')) -
                  rekapKas.editKasAwalRekapC;
              int kasAkhir = int.parse(rekapKas.kasAkhirNewRekapC.text
                  .substring(4)
                  .replaceAll(',', ''));
              putApiUpdateRekapKas.connectAPI(
                rekapKas.idRekapKas,
                kasAkhir,
                selisih,
              );
            },
            child: Container(
                alignment: Alignment.center,
                width: 90,
                height: 35,
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(20)),
                child: const Text(
                  'Simpan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
