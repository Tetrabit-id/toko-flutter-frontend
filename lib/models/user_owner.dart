class Owner {
  String? id;
  String? cabangId;
  String? email;
  String? name;
  String? store;
  String? role;
  String? plan;
  bool owner;
  bool statusPembayaran;
  String? token;

  Owner({
    this.id,
    this.cabangId,
    this.email,
    this.name,
    this.store,
    this.role,
    this.plan,
    this.owner = true,
    this.statusPembayaran = false,
    this.token,
  });

  factory Owner.fromJson(json) {
    return Owner(
      id: json['_id'],
      cabangId: json['cabangId'],
      email: json['email'],
      name: json['name'],
      store: json['store'],
      role: json['role'],
      plan: json['plan'] ?? 'subscription',
      owner: json['owner'],
      statusPembayaran: json['statusPembayaran'],
      token: json['token'],
    );
  }
}
