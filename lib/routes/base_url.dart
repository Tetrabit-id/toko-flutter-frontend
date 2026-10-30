import 'package:get_storage/get_storage.dart';

import '../config/env.dart';

// baseUrl berdasar pada url backend golang dijalankan, diatur di env/*.json
const baseUrl = Env.baseUrl;
const baseUrlWS = Env.baseUrlWS;
var token = GetStorage();
