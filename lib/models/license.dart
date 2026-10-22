class License {
  String? licenseId;
  String? userId;
  String? plan;
  String? deviceId;
  String? store;
  String? issuedAt;

  License({
    this.licenseId,
    this.userId,
    this.plan,
    this.deviceId,
    this.store,
    this.issuedAt,
  });

  factory License.fromJson(json) {
    return License(
      licenseId: json['licenseId'],
      userId: json['userId'],
      plan: json['plan'],
      deviceId: json['deviceId'],
      store: json['store'],
      issuedAt: json['issuedAt'],
    );
  }
}
