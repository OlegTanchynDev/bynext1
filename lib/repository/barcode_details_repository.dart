import 'dart:convert';

import 'package:bynextcourier/client/app_http_client.dart';
import 'package:bynextcourier/model/barcode_details.dart';
import 'package:bynextcourier/model/rest_error.dart';
import 'package:http/http.dart';

import '../constants.dart';

class BarcodeDetailsRepository {
  Future<List> fetchOrderAssignedBarcodes(Client http, String token, String orderId) async {
    final response = await http.get(
      '$servicesUrl/delivery/v2/barcode/getOrderAssignedBarcodes/' + (!(http is DemoHttpClient) ? '?order_id=$orderId' : ''),
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
        'Accept-Encoding': "gzip",
      },
    ).timeout(requestTimeout);

    List<BarcodeDetails> details = [];
    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      parsed.forEach((element) {
        details.add(BarcodeDetails.fromMap(element));
      });
      return Future.value(details);
    } else {
      throw RestError.fromMap(parsed);
    }
  }

  Future<List> fetchOrderNotes(Client http, String token, String orderId) async {
    final response = await http.get(
      '$servicesUrl/delivery/v2/order/getOrderNotes/' + (!(http is DemoHttpClient) ? orderId : ''),
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
        'Accept-Encoding': "gzip",
      },
    ).timeout(requestTimeout);

    List<OrderNote> notes = [];
    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      parsed.forEach((element) {
        notes.add(OrderNote.fromMap(element));
      });
      return Future.value(notes);
    } else {
      throw RestError.fromMap(parsed);
    }
  }
}
