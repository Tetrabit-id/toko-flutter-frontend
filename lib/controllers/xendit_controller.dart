// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

const xenditUrl = 'https://api.xendit.co/v2/invoices';

class XenditService extends GetxController {
  Future createInvoice(num amount) async {
    try {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      Map data = {
        "external_id": "invoice-$timestamp",
        "amount": amount,
        "description": "Invoice #$timestamp",
      };

      var body = json.encode(data);

      var url = Uri.parse(xenditUrl);
      var response = await http.post(url,
          headers: <String, String>{
            "Authorization":
                "Basic eG5kX2RldmVsb3BtZW50X1RGNE0xR3pFR1BucFdsTmpKTDB5Y2thcVBCV0tFRXphOXAycGd6REJkSTdvT2tVR0dRbnFBaGhHZkwxY3Bmdzo=",
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        return decodedResponse["invoice_url"];
      }
    } catch (e) {
      print(e);
    }
  }
}
