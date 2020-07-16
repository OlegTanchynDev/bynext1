import 'dart:convert';

import 'package:bynextcourier/client/app_http_client.dart';
import 'package:flutter/material.dart';

class DemoResponse {
  final String _assetPath;

  String assetPath(DemoTasks demoTask) => _assetPath;

  Future<String> getStringResponse(BuildContext context, String url, String method, DemoTasks currentTask, [body]) {
    return DefaultAssetBundle.of(context).loadString(assetPath(currentTask));
  }

  DemoResponse(this._assetPath);
}

class DemoTaskResponse extends DemoResponse {
  DemoTaskResponse() : super(null);

  @override
  String assetPath(DemoTasks demoTask) {
    String jsonName = "";
    switch (demoTask) {
      case DemoTasks.pickupFromClient:
      case DemoTasks.pickupFromClientPu:
        jsonName = "tasks_getTask_customer_pickup";
        break;
      case DemoTasks.laundromatPickup:
      case DemoTasks.laundromatPickupPu:
        jsonName = "tasks_getTask_warehouse_pickup";
        break;
      case DemoTasks.laundromatDropoff:
      case DemoTasks.laundromatDropoffPu:
        jsonName = "tasks_getTask_warehouse_drop_off";
        break;
      case DemoTasks.gotoLocation:
        jsonName = "tasks_getTask_manual";
        break;
      case DemoTasks.batched:
        jsonName = "tasks_getTask_batched";
        break;
      case DemoTasks.deliverToClient:
        jsonName = "tasks_getTask";
        break;
    }

    return "assets/mock/regular-business/$jsonName.json";
  }
}

class BarcodeResponse extends DemoResponse {
  dynamic barcodes;

  BarcodeResponse(String assetPath) : super(assetPath);

  @override
  Future<String> getStringResponse(BuildContext context, String url, String method, DemoTasks currentTask,
      [body]) async {
    if (barcodes == null) {
      final str = await DefaultAssetBundle.of(context).loadString(assetPath(currentTask));
      barcodes = json.decode(str);
    }

    if (method == 'post') {
      // modifies list
      if (url.endsWith('delivery/v2/barcode/assign/pickupBarcode/')) {
        final barcode = body['scanned_barcode'];
        if (barcodes.where((item) => item['barcode'] == barcode).length == 0) {
          barcodes.add(<String, dynamic>{"status": 5, "id": 260, "type": 0, "barcode": barcode});
        }

        return '''{
          "message" : "",
          "data" : "",
          "status_code" : "0"
        }''';
      } else if (url.endsWith('delivery/v2/barcode/unassign/pickupBarcode/')) {
        final barcode = body['scanned_barcode'];
        barcodes.removeWhere((item) => item['barcode'] == barcode);

        return '''{
          "message" : "",
          "data" : "",
          "status_code" : "0"
        }''';
      }
    }

    return json.encode(barcodes);
  }
}
