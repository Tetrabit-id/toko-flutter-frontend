import 'package:get_storage/get_storage.dart';

// baseUrl berdasar pada url backend golang dijalankan
var baseUrl = "http://localhost:8000";
var baseUrlWS = "http://localhost:8001";
// var baseUrl = "https://toko.tetrabit.my.id/api";
// var baseUrlWS = "wss://toko.tetrabit.my.id/ws";
var token = GetStorage();
