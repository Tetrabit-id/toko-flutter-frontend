import 'package:tetrabit_toko_pos/constructors/button_primary.dart';
import 'package:tetrabit_toko_pos/constructors/text_field_rounded.dart';
import 'package:tetrabit_toko_pos/constructors/text_style.dart';
import 'package:tetrabit_toko_pos/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/state_global.dart';

class AddCabangPage extends StatefulWidget {
  const AddCabangPage({Key? key}) : super(key: key);

  @override
  State<AddCabangPage> createState() => _AddCabangPageState();
}

class _AddCabangPageState extends State<AddCabangPage> {
  String? scannerQr = '';

  @override
  Widget build(BuildContext context) {
    final querySize = MediaQuery.of(context);
    Size size = MediaQuery.of(context).size;

    return MediaQuery(
      data: querySize.copyWith(textScaler: const TextScaler.linear(0.81)),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            title: const Text('Buat Cabang Baru',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w600)),
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppSvg.cabangSvg,
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 60,
                          child: textFieldRounded(
                            'Nama Cabang',
                            postApiInsertCabang.nmCbNewC,
                            false,
                            TextInputType.text,
                            false,
                            size,
                          ),
                        ),
                      ],
                    ),
                    textFieldRounded(
                      'No Telpon Admin',
                      postApiInsertCabang.noTelpCbNewC,
                      false,
                      TextInputType.number,
                      false,
                      size,
                    ),
                    textFieldRounded(
                      'Lokasi Cabang',
                      postApiInsertCabang.alamatCbNewC,
                      false,
                      TextInputType.text,
                      false,
                      size,
                    ),
                    const SizedBox(height: 30),
                    buttonPrimary(
                        'Buat Cabang',
                        postApiInsertCabang.nmCbNewC.text != '' &&
                                postApiInsertCabang.noTelpCbNewC.text != '' &&
                                postApiInsertCabang.alamatCbNewC.text != ''
                            ? AppColors.primaryColor
                            : Colors.grey,
                        Colors.white,
                        Colors.transparent,
                        Size(size.width - 140, size.height / 20),
                        () => setState(() {
                              postApiInsertCabang.connectAPI(
                                capitalizeEachWord(
                                    postApiInsertCabang.nmCbNewC.text),
                                capitalizeEachWord(
                                    postApiInsertCabang.alamatCbNewC.text),
                                postApiInsertCabang.noTelpCbNewC.text,
                              );
                            }))
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
