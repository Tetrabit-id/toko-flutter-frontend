class Cabang {
  String? id;
  String? name;
  String? alamat;
  String? noTelp;

  Cabang({
    this.id,
    this.name,
    this.alamat,
    this.noTelp,
  });

  factory Cabang.fromJson(json) {
    return Cabang(
      id: json['_id'],
      name: json['name'],
      alamat: json['alamat'],
      noTelp: json['noTeleponAdmin'],
    );
  }
}
