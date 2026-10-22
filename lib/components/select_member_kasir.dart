import 'package:tetrabit_toko_pos/style/styles.dart';
import 'package:flutter/material.dart';
import '../routes/state_global.dart';

class SelectMemberKasirPage extends StatefulWidget {
  const SelectMemberKasirPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectMemberKasirPage> createState() => _SelectMemberKasirPageState();
}

class _SelectMemberKasirPageState extends State<SelectMemberKasirPage> {
  String? scannerQr = '';

  @override
  void initState() {
    super.initState();
    getApiPelanggan.getApi();
    pelanggan.dataPelanggan = getApiPelanggan.dataPelanggan;
  }

  @override
  RawAutocomplete build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final querySize = MediaQuery.of(context);
    Iterable resultFilter;
    return RawAutocomplete<String>(
      focusNode: FocusNode(),
      textEditingController: pelanggan.controllerFieldC,
      optionsBuilder: (keyword) {
        if (keyword.text.isEmpty) {
          return pelanggan.dataPelanggan.toList().map((e) => e['memberId']!);
        } else {
          var results = pelanggan.dataPelanggan.toList();
          resultFilter = results
              .where((element) =>
                  element['name']!
                      .toLowerCase()
                      .contains(keyword.text.toLowerCase()) ||
                  element['memberId']!
                      .toLowerCase()
                      .contains(keyword.text.toLowerCase()))
              .toList();

          return resultFilter.map((e) => e['memberId']!);
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
                  List memberId = pelanggan.dataPelanggan
                      .toList()
                      .map((e) => e['memberId']!)
                      .toList();

                  List memberById = pelanggan.dataPelanggan
                      .toList()
                      .map((e) => e['_id']!)
                      .toList();

                  List memberName = pelanggan.dataPelanggan
                      .toList()
                      .map((e) => e['name']!)
                      .toList();

                  var memberType = memberId[index].toString();
                  var id = memberById[index];
                  var name = memberName[index];

                  return MediaQuery(
                    data: querySize.copyWith(textScaleFactor: 0.81),
                    child: ListTile(
                      title: Text(name),
                      trailing: Text(
                        'Member ID : $memberType',
                        style:
                            const TextStyle(color: AppColors.colorFontSecond),
                      ),
                      onTap: () {
                        onSelected(option.toString());
                        setState(() {
                          pelanggan.filterC.text = id.toString();
                          pelanggan.foundPelangganId.value = true;
                        });
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
                value.isEmpty
                    ? pelanggan.foundPelangganId.value = false
                    : pelanggan.foundPelangganId.value = true;
              },
              cursorHeight: 18,
              decoration: InputDecoration(
                icon: GestureDetector(
                    onTap: () async {
                      controller.text = await nfc.readNFC();
                      controller.text.isNotEmpty
                          ? pelanggan.foundPelangganId.value = true
                          : pelanggan.foundPelangganId.value = false;
                      for (var e in pelanggan.dataPelanggan) {
                        if (e['memberId'] == controller.text) {
                          pelanggan.filterC.text = e['_id'];

                          getApiPelanggan.getByIdApi(pelanggan.filterC.text);
                          pelanggan.filterC.clear();
                          pelanggan.controllerFieldC.clear();
                          pelanggan.foundPelangganId.value = false;
                        }
                      }
                    },
                    child: const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: AppColors.primaryColor,
                    )),
                suffixIcon: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      controller.clear();
                      kasir.filterC.clear();
                      nfc.dataNfc.value = "";
                      pelanggan.foundPelangganId.value = false;
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
                hintText: 'Cari member id..',
              )),
        );
      },
    );
  }
}
