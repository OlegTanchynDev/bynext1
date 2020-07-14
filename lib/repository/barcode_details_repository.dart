import 'dart:convert';

import 'package:bynextcourier/client/app_http_client.dart';
import 'package:bynextcourier/model/rest_error.dart';
import 'package:http/http.dart';

import '../constants.dart';

class BarcodeDetailsRepository {
  Future<List> fetchOrderAssignedBarcodes(Client http, String token, int taskId) async {
    final response = await http.get(
      '$servicesUrl/delivery/v2/barcode/getOrderAssignedBarcodes/' + (!(http is DemoHttpClient) ? '?order_id=$taskId' : ''),
      headers: {
//        'content-type': 'application/json',
        'Authorization': "Token $token",
        'Accept-Encoding': "gzip",
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return Future.value([]);
    } else {
      throw RestError.fromMap(parsed);
    }
  }
}
