import 'dart:convert';

import 'package:bynextcourier/model/rest_error.dart';
import 'package:http/http.dart';

import '../constants.dart';

class BarcodeStatusRepository {
  Future<bool> setBarcodeStatus(
    Client http,
    String token,
    String barcode,
    num status,
    String orderId,
    int taskId,
    bool singleBagPickup,
  ) async {
    final uri = Uri.parse('$servicesUrl/delivery/v2/dropshop/setBarcodeStatus/');
    final isPickupBag = barcode.startsWith('PU');

    uri.queryParameters['barcode'] = barcode;
    uri.queryParameters['status'] = status.toString();

    if (!isPickupBag || (orderId?.length ?? 0) > 0) {
      uri.queryParameters['order_id'] = orderId ?? '';
    }
    if (singleBagPickup && isPickupBag) {
      uri.queryParameters['task_id'] = taskId?.toString() ?? '';
    }

    final response = await http.get(
      uri,
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
        'Accept-Encoding': "gzip",
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);
    if (response.statusCode == 200) {
      final ok = int.tryParse(parsed['status_code'] ?? '-1') == 0;
      if (ok) {
        return true;
      } else {
        throw RestError(errors: <String, String>{'non_field_errors': parsed['message']});
      }
    } else {
      throw RestError.fromMap(parsed);
    }
  }
}
