import 'package:tetrabit_toko_pos/constructors/text_style.dart';
import 'package:flutter/material.dart';

import '../constructors/text_field_rounded.dart';
import '../routes/base_url.dart';
import '../routes/state_global.dart';
import '../style/styles.dart';

class PopUpMerkProduk extends StatelessWidget {
  const PopUpMerkProduk({
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
          textFieldRounded(
            'Nama Merk',
            stok.nmMPrdC,
            false,
            TextInputType.text,
            false,
            size,
          ),
          textFieldRounded(
            'Kode Merk',
            stok.kodeMPrdC,
            false,
            TextInputType.text,
            false,
            size,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              var idOwner = token.read('role') != 'admin'
                  ? token.read('parentId')
                  : token.read('_id');
              await postApiInsertMerkProduk.connectAPI(
                idOwner,
                stok.kodeMPrdC.text,
                capitalizeEachWord(stok.nmMPrdC.text),
              );

              await getApiMerkProduk.getApi();
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
