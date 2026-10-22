class User {
  String? id;
  String? cabangId;
  String? email;
  String? name;
  String? store;
  String? role;
  String? parent;
  bool? owner;
  bool? statusPembayaran;
  String? token;

  User({
    this.id,
    this.cabangId,
    this.email,
    this.name,
    this.store,
    this.role,
    this.parent,
    this.owner,
    this.statusPembayaran,
    this.token,
  });

  factory User.fromJson(json) {
    return User(
      id: json['_id'],
      cabangId: json['cabangId'],
      email: json['email'],
      name: json['name'],
      store: json['store'],
      role: json['role'],
      parent: json['parent'],
      owner: json['owner'],
      statusPembayaran: json['status_pembayaran'],
      token: json['token'],
    );
  }
}
