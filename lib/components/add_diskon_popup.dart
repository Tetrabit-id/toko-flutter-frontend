import 'package:flutter/material.dart';

import '../constructors/text_field_rounded.dart';
import '../routes/state_global.dart';
import '../style/styles.dart';

class PopUpDiskon extends StatefulWidget {
  const PopUpDiskon({super.key});

  @override
  State<PopUpDiskon> createState() => _PopUpDiskonState();
}

class _PopUpDiskonState extends State<PopUpDiskon> {
  @override
  Widget build(BuildContext context) {
    void btnDiskonByRp() {
      if (kasir.discountByRp.value) {
        return;
      }
      setState(() {
        kasir.discountByRp.value = true;
        kasir.diskonC.clear();
      });
      return;
    }

    void btnDiskonByPersentage() {
      if (!kasir.discountByRp.value) {
        return;
      }

      setState(() {
        kasir.discountByRp.value = false;
        kasir.diskonC.clear();
      });
      return;
    }

    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => btnDiskonByRp(),
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(120, 0),
                      elevation: 0,
                      backgroundColor: kasir.discountByRp.value
                          ? AppColors.primaryColor
                          : Colors.grey,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      )),
                  child: const Text('Rp')),
              const SizedBox(width: 5),
              ElevatedButton(
                  onPressed: () => btnDiskonByPersentage(),
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(120, 0),
                      elevation: 0,
                      backgroundColor: kasir.discountByRp.value == true
                          ? Colors.grey
                          : AppColors.primaryColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      )),
                  child: const Text('%'))
            ],
          ),
          kasir.discountByRp.value
              ? textFieldRoundedCurrentwithHint('Diskon', kasir.diskonC, false,
                  TextInputType.number, 'Rp.', TextAlign.start, size)
              : textFieldRoundedwithHint('Diskon', kasir.diskonC, false,
                  TextInputType.number, '%', TextAlign.start, size, 2),
          textFieldRounded(
            'Nama Diskon',
            kasir.namaDiskonC,
            false,
            TextInputType.text,
            false,
            size,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => kasir.diskon(),
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
