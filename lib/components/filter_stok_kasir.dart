import 'package:diatera_pos/routes/base_url.dart';
import 'package:diatera_pos/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../routes/state_global.dart';

class FilterStokKasirPage extends StatefulWidget {
  const FilterStokKasirPage({
    Key? key,
  }) : super(key: key);

  @override
  State<FilterStokKasirPage> createState() => _FilterStokKasirPageState();
}

class _FilterStokKasirPageState extends State<FilterStokKasirPage> {
  String? scannerQr = '';

  @override
  void initState() {
    super.initState();
    if (token.read('role') != 'admin') {
      getApiStok.getAPI(token.read('parentId'), token.read('cabangId'));
      stok.dataStok = getApiStok.dataStok;
      return;
    }

    getApiStok.getAPI(token.read('_id'), token.read('cabangId'));
    stok.dataStok = getApiStok.dataStok;
  }

  @override
  RawAutocomplete build(BuildContext context) {
    String sisaStok = '';

    Size size = MediaQuery.of(context).size;
    final querySize = MediaQuery.of(context);
    Iterable resultFilter;
    return RawAutocomplete<String>(
      focusNode: FocusNode(),
      textEditingController: kasir.controllerFieldC,
      optionsBuilder: (keyword) {
        if (keyword.text.isEmpty) {
          return stok.dataStok.toList().map((e) => e['name']!);
        } else {
          var results = stok.dataStok.toList();
          resultFilter = results
              .where((element) =>
                  element['name']!
                      .toLowerCase()
                      .contains(keyword.text.toLowerCase()) ||
                  element['code']!
                      .toLowerCase()
                      .contains(keyword.text.toLowerCase()))
              .toList();

          return resultFilter.map((e) => e['name']!);
        }
      },
      optionsViewBuilder: (context, Function(String) onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            type: MaterialType.canvas,
            elevation: 4,
            child: SizedBox(
              width: 250,
              height: 200,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  List stokBrg =
                      stok.dataStok.toList().map((e) => e['qty']!).toList();
                  List nmBrg =
                      stok.dataStok.toList().map((e) => e['name']!).toList();
                  for (var i = 0; i < nmBrg.length; i++) {
                    if (option == nmBrg[i]) {
                      sisaStok = stokBrg[i].toString();
                    }
                  }

                  return MediaQuery(
                    data: querySize.copyWith(textScaleFactor: 0.81),
                    child: ListTile(
                      title: Text(option.toString()),
                      trailing: Text(
                        'Sisa stok : $sisaStok',
                        style:
                            const TextStyle(color: AppColors.colorFontSecond),
                      ),
                      onTap: () {
                        onSelected(option.toString());
                        kasir.filterC.text = option.toString();
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        Future<void> scanQR() async {
          scannerQr = await FlutterBarcodeScanner.scanBarcode(
              '#ff6666', 'Cancel', true, ScanMode.BARCODE);
          setState(() {
            controller.text = scannerQr!;
            if (controller.text == '-1') {
              controller.clear();
            }
            kasir.filterC.text = controller.text;
            kasir.addFilterDataStok(
              kasir.filterC.text,
              stok.dataStok.toList(),
              kasir.filterC.text,
            );

            FocusScope.of(context).requestFocus(FocusNode());
            kasir.controllerFieldC.clear();
            kasir.filterC.clear();
          });
        }

        return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width / 200,
            ),
            child: TextField(
                textAlignVertical: TextAlignVertical.center,
                focusNode: focusNode,
                controller: controller,
                onEditingComplete: onEditingComplete,
                onChanged: (value) {
                  String data = '';
                  data = value;
                  kasir.filterC.text = data;
                },
                cursorHeight: 18,
                decoration: InputDecoration(
                  icon: GestureDetector(
                      onTap: () => scanQR(),
                      child: const Icon(
                        Icons.qr_code_scanner_rounded,
                        color: AppColors.primaryColor,
                      )),
                  suffixIcon: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        controller.clear();
                        kasir.filterC.clear();
                      },
                      child: const Icon(Icons.close_rounded)),
                  contentPadding: const EdgeInsets.only(left: 10),
                  isDense: true,
                  filled: true,
                  enabled: true,
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
                  hintText: 'Cari nama barang, kode barang',
                )));
      },
    );
  }
}
