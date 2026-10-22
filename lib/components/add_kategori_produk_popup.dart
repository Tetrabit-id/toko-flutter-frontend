import 'package:diatera_pos/constructors/text_style.dart';
import 'package:flutter/material.dart';

import '../constructors/text_field_rounded.dart';
import '../routes/base_url.dart';
import '../routes/state_global.dart';
import '../style/styles.dart';

class PopUpKategoriProduk extends StatelessWidget {
  const PopUpKategoriProduk({
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
            'Nama Kategori',
            stok.nmKPrdC,
            false,
            TextInputType.text,
            false,
            size,
          ),
          textFieldRounded(
            'Kode Kategori',
            stok.kodeKPrdC,
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
              await postApiInsertKategoriProduk.connectAPI(
                idOwner,
                stok.kodeKPrdC.text,
                capitalizeEachWord(stok.nmKPrdC.text),
              );

              await getApiKategoriProduk.getApi();
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
