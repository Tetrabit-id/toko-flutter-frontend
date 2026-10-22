import 'package:flutter/material.dart';

import '../constructors/text_field_rounded.dart';
import '../routes/state_global.dart';
import '../style/styles.dart';

class PopUpAkun extends StatelessWidget {
  const PopUpAkun({
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
            'Nama Lengkap',
            auth.editUsernameC,
            false,
            TextInputType.text,
            false,
            size,
          ),
          textFieldRounded(
            'Toko',
            auth.editTokoC,
            false,
            TextInputType.text,
            false,
            size,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => putApiUpdateAkun.connectAPI(
              auth.editUsernameC.text,
              auth.editTokoC.text,
            ),
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
