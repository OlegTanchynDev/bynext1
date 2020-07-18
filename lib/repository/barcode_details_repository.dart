import 'dart:convert';

import 'package:bynextcourier/client/app_http_client.dart';
import 'package:bynextcourier/model/barcode_details.dart';
import 'package:bynextcourier/model/rest_error.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:http/http.dart';

import '../constants.dart';

class BarcodeDetailsRepository {
  Future<List<BarcodeDetails>> fetchOrderAssignedBarcodes(Client http, String token, String orderId) async {
    print('$servicesUrl/delivery/v2/barcode/getOrderAssignedBarcodes/?order_id=$orderId');
    final response = await http.get(
      '$servicesUrl/delivery/v2/barcode/getOrderAssignedBarcodes/?order_id=$orderId',
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

  Future<bool> addNewBarcode(Client http, String token, String barcode, Task task) async {
    final response = await http.post(
      '$servicesUrl/delivery/v2/barcode/assign/pickupBarcode/',
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
        'Accept-Encoding': "gzip",
      },
      body: {
        "scanned_barcode": barcode,
        "order_friendly_id": task.meta.orderId,
        "task_id": task.id,
      }
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body) as Map;
      if (responseBody['status_code'] == "0") {
        return Future.value(true);
      }
      else {
        return Future.value(false);
      }
    } else {
      throw RestError.fromMap(parsed);
    }
  }

  Future<bool> removeBarcode(Client http, String token, String barcode, Task task) async {
    final response = await http.post(
      '$servicesUrl/delivery/v2/barcode/unassign/pickupBarcode/',
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
        'Accept-Encoding': "gzip",
      },
      body: {
        "scanned_barcode": barcode,
//        "order_friendly_id": task.meta.orderId,
        "task_id": task.id,
      }
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return Future.value(true);
    } else {
      throw RestError.fromMap(parsed);
    }
  }

  Future<List<OrderNote>> fetchOrderNotes(Client http, String token, String orderId) async {
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

  Future<bool> addNewOrderNote(Client http, String token, OrderNote note, String orderId) async {
    final response = await http.post(
      '$servicesUrl/delivery/v2/order/addOrderNotes/$orderId',
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
        'Accept-Encoding': "gzip",
      },
      body: {
        "note": note.text,
        "imageUrl": note.image,
      }
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body) as Map;
      if (responseBody['status_code'] == "0") {
        return Future.value(true);
      }
      else {
        return Future.value(false);
      }
    } else {
      throw RestError.fromMap(parsed);
    }
  }
}
