import 'package:tetrabit_toko_pos/routes/state_global.dart';
import 'package:get/get.dart';

class TransaksiController extends GetxController {
  late List dataLaporanHariIni = List.empty().obs;
  late List dataLaporan7Ago = List.empty().obs;
  num totalPemasukkan = 0;
  num pendapatanHariIni = 0;
  num pendapatanBulanan = 0;
  int counter = 0;

  Future<List> getTransaksiDateNow() async {
    String date = '${DateTime.now()}';
    await getApiTransaksi.getApi();
    dataLaporanHariIni = getApiTransaksi.dataLaporan
        .where((data) => data['date'] == date.substring(0, 10))
        .toList();
    return dataLaporanHariIni;
  }

  Future<List> getTransaksiDate7Ago() async {
    dataLaporan7Ago.clear();
    await getApiTransaksi.getApi();
    for (var i = 0; i < 7; i++) {
      dataLaporan7Ago.add(getApiTransaksi.dataLaporan
          .where((data) =>
              data['date'] ==
              '${DateTime.now().subtract(Duration(days: i))}'.substring(0, 10))
          .toList());
    }
    return dataLaporan7Ago;
  }

  Future<num> getPemasukanHariIni(String date) async {
    String date = '${DateTime.now()}';
    num pendapatanNow = 0;
    List getTanggal = [];
    num jmlTransaksi;
    await getApiTransaksi.getApi();
    getTanggal = getApiTransaksi.dataLaporan
        .where((data) => data['date'] == date.substring(0, 10))
        .toList();
    for (var i = 0; i < getTanggal.length; i++) {
      jmlTransaksi = getTanggal[i]['jumlahTransaksi'];
      pendapatanNow = pendapatanNow + jmlTransaksi;
    }
    return pendapatanHariIni = pendapatanNow;
  }

  Future<num> getPemasukanMonth(String date) async {
    String date = '${DateTime.now()}';
    num pendapatanNow = 0;
    List getTanggal = [];
    num jmlTransaksi;

    await getApiTransaksi.getApi();
    getTanggal = getApiTransaksi.dataLaporan
        .where((data) =>
            data['date'].toString().substring(0, 7) == date.substring(0, 7))
        .toList();
    for (var i = 0; i < getTanggal.length; i++) {
      jmlTransaksi = getTanggal[i]['jumlahTransaksi'];
      pendapatanNow = pendapatanNow + jmlTransaksi;
    }
    return pendapatanBulanan = pendapatanNow;
  }

  // Pendapatan per pelanggan (member) pada bulan yyyy-MM, terbesar dulu.
  // Bentuk item: {name, memberId, jumlah, total}
  Future<List<Map<String, dynamic>>> getPendapatanPerPelanggan(
      String bulan) async {
    await getApiTransaksi.getApi();
    await getApiPelanggan.getApi();
    var member = {for (var p in getApiPelanggan.dataPelanggan) p['_id']: p};

    var hasil = <String, Map<String, dynamic>>{};
    for (var t in getApiTransaksi.dataLaporan) {
      var id = t['membershipsId'];
      if (id == null || id == '' || !'${t['date']}'.startsWith(bulan)) {
        continue;
      }
      var item = hasil.putIfAbsent(
          id,
          () => {
                'name': member[id]?['name'] ?? 'Pelanggan terhapus',
                'memberId': member[id]?['memberId'] ?? '',
                'jumlah': 0,
                'total': 0,
              });
      item['jumlah'] += 1;
      item['total'] += t['jumlahTransaksi'] ?? 0;
    }

    return hasil.values.toList()
      ..sort((a, b) => (b['total'] as num).compareTo(a['total'] as num));
  }

  Future<num> getTotalPemasukkan() async {
    num counting = 0;
    await getApiTransaksi.getApi();
    for (var i = 0; i < getApiTransaksi.dataLaporan.length; i++) {
      counting = counting + getApiTransaksi.dataLaporan[i]['jumlahTransaksi'];
    }
    return totalPemasukkan = counting;
  }
}
