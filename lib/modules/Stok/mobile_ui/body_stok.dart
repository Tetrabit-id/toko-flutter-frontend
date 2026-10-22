import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/loading_cilcular.dart';
import '../../../components/stok_card.dart';
import '../../../constructors/text_field_default.dart';
import '../../../constructors/text_style.dart';
import '../../../routes/base_url.dart';
import '../../../routes/state_global.dart';
import '../../../style/styles.dart';

class BodyStok extends StatefulWidget {
  const BodyStok({super.key, this.size, this.idCabang});

  final Size? size;
  final String? idCabang;
  @override
  State<BodyStok> createState() => _BodyStokState();
}

class _BodyStokState extends State<BodyStok> {
  @override
  void initState() {
    super.initState();
    setState(() {
      if (token.read('role') != 'admin') {
        getApiStok.getAPI(token.read('parentId'), widget.idCabang);
      }

      stok.foundStok = getApiStok.dataStok;
    });
  }

  void filterStok(String keyword) async {
    List resultFilter = [];
    if (keyword.isEmpty) {
      resultFilter = getApiStok.dataStok.toList();
    } else {
      var results = getApiStok.dataStok.toList();

      resultFilter = results
          .where((element) =>
              element['name']!.toLowerCase().contains(keyword.toLowerCase()) ||
              element['code']!.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() {
      stok.foundStok = resultFilter.obs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          textFieldDefaultIcon(
            'Cari nama barang, kode barang',
            const Size(115, 20),
            false,
            const Icon(Icons.search),
            (value) => filterStok(value),
          ),
          const SizedBox(height: 5),
          RefreshIndicator(
            onRefresh: (() {
              token.read('role') != 'admin' ? null : getApiCabang.getAPI();
              return token.read('role') != 'admin'
                  ? getApiStok.getAPI(token.read('parentId'), widget.idCabang)
                  : getApiStok.getAPI(token.read('_id'), widget.idCabang);
            }),
            child: FutureBuilder(
                future: token.read('role') != 'admin'
                    ? getApiStok.getAPI(token.read('parentId'), widget.idCabang)
                    : getApiStok.getAPI(token.read('_id'), widget.idCabang),
                initialData: getApiStok.dataStok,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                        height: widget.size!.height / 10,
                        child: const LoadingCilcular());
                  }
                  return StreamBuilder(
                    stream: getApiStok.dataStok.stream,
                    builder: (context, snapshot) {
                      return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: getApiStok.dataStok.isEmpty
                              ? SizedBox(
                                  width: widget.size!.width,
                                  height: widget.size!.height / 1.5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AppSvg.notFoundStokSvg,
                                      const SizedBox(height: 25),
                                      headerNotFound('Stok kosong'),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                )
                              : Obx(
                                  () => Container(
                                    height: widget.size!.height,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: stok.foundStok.length,
                                        separatorBuilder: (context, index) =>
                                            const Divider(
                                                color: Colors.grey, height: 25),
                                        itemBuilder: (context, index) =>
                                            FilterStokCard(
                                                index: index,
                                                role: token.read('role'))),
                                  ),
                                ));
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
