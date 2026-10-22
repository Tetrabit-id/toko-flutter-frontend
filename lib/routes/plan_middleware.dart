import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'route.dart';

// Menolak route yang tidak termasuk paket aktif (mis. obrolan di paket offline).
// Menu-menunya sudah disembunyikan; ini pengaman jika route tetap dipanggil.
class PlanMiddleware extends GetMiddleware {
  PlanMiddleware(this.allowed);
  final bool Function() allowed;

  @override
  RouteSettings? redirect(String? route) =>
      allowed() ? null : const RouteSettings(name: RouteName.index);
}
