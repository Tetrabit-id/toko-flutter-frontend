class Kasir {
  String? id;
  String? userId;
  String? cabangId;
  String? stokId;
  String? produkId;
  String? noInv;
  String? kodeBarang;
  String? namaBarang;
  String? fotoBarang;
  num qtyStok;
  num hargaBarangStok;
  num qtyPembelian;
  num totalHarga;

  Kasir({
    this.id,
    this.userId,
    this.cabangId,
    this.stokId,
    this.produkId,
    this.noInv,
    this.kodeBarang,
    this.namaBarang,
    this.fotoBarang,
    this.qtyStok = 0,
    this.hargaBarangStok = 0,
    this.qtyPembelian = 0,
    this.totalHarga = 0,
  });
}
