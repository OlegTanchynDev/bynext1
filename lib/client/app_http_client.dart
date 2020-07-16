import 'dart:convert';

import 'package:bynextcourier/helpers/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'demo_response.dart';


class DemoHttpClient extends BaseClient {

  static BarcodeResponse barcodeResponse = BarcodeResponse('assets/mock/regular-business/barcode_getOrderAssignedBarcodes.json');

  final requestsMap = <String, DemoResponse>{
    '$servicesUrl/delivery/v2/shift/getShiftDetails/': DemoResponse('assets/mock/regular-business/shift_getShiftDetails.json'),
    '$servicesUrl/delivery/v2/courier/getCourierProfile/':DemoResponse('assets/mock/regular-business/courier_getCourierProfile.json'),

    '$servicesUrl/delivery/v2/payment/':DemoResponse('assets/mock/regular-business/v2_payment.json'),
    '$servicesUrl/delivery/v2/payment/?payment_period_id=8':DemoResponse('assets/mock/regular-business/v2_payment_1.json'),
    '$servicesUrl/delivery/v2/payment/?payment_period_id=7':DemoResponse('assets/mock/regular-business/v2_payment_2.json'),
    '$servicesUrl/delivery/v2/payment/?payment_period_id=11':DemoResponse('assets/mock/regular-business/v2_payment.json'),

    // Shifts
    '$servicesUrl/delivery/v2/shift/getShiftTypes/': DemoResponse('assets/mock/regular-business/shift_getShiftTypes.json'),
    '$servicesUrl/delivery/v2/shift/getShifts/': DemoResponse('assets/mock/regular-business/shift_getShifts.json'),
    '$servicesUrl/delivery/v2/shift/getUpcomingShifts/': DemoResponse('assets/mock/regular-business/shift_getUpcomingShifts.json'),

    //Tasks
    '$servicesUrl/delivery/v2/tasks/getTask/': DemoTaskResponse(),
    '$servicesUrl/delivery/v2/tasks/getTask/?&shift_id=484': DemoTaskResponse(),

    //task go to location
    '$servicesUrl/delivery/v2/location/arriveAtPlace?taskId=312&lat=40.688124&lng=-73.99238': DemoResponse('assets/mock/regular-business/location_arriveAtPlace.json'),
    '$servicesUrl/delivery/v2/location/arriveAtPlace?taskId=312': DemoResponse('assets/mock/regular-business/location_arriveAtPlace.json'),
    '$servicesUrl/delivery/v2/location/arriveAtPlace?taskId=312&lat=null&lng=null': DemoResponse('assets/mock/regular-business/location_arriveAtPlace.json'),
    '$servicesUrl/delivery/v2/location/arriveAtPlace?taskId=294&lat=null&lng=null': DemoResponse('assets/mock/regular-business/location_arriveAtPlace.json'),
    '$servicesUrl/delivery/v2/location/arriveAtPlace?taskId=298&lat=null&lng=null': DemoResponse('assets/mock/regular-business/location_arriveAtPlace.json'),
    '$servicesUrl/delivery/v2/tasks/getTask/?&route_id=484': DemoTaskResponse(),

    //task pickup from client
    '$servicesUrl/delivery/v2/order/getOrderNotes/': DemoResponse('assets/mock/regular-business/getOrderNotes.json'),
    '$servicesUrl/delivery/v2/barcode/assign/pickupBarcode/' : barcodeResponse,
    '$servicesUrl/delivery/v2/barcode/unassign/pickupBarcode/' : barcodeResponse,
    '$servicesUrl/delivery/v2/barcode/getOrderAssignedBarcodes/?order_id=6TGALQ': barcodeResponse,

    //task pickup from client
    '$servicesUrl/delivery/v2/chat/token/?task_id=312': DemoResponse('assets/mock/regular-business/chat_token.json'),

    // task deliver to customer
    '$servicesUrl/delivery/v2/location/arriveAtPlace?taskId=289&lat=null&lng=null': DemoResponse('assets/mock/regular-business/location_arriveAtPlace.json'),

  };

  final BuildContext context;
  DemoTasks currentTask = DemoTasks.pickupFromClient;

  DemoHttpClient(this.context);

  @override
  Future<Response> get(url, {Map<String, String> headers}) {
    printLabel('get url:$url', 'Client');
    final request = requestsMap[url];
    if (request != null) {
      return Future.delayed(Duration(seconds: 1), () async => http.Response(await request.getStringResponse(context, url, 'get', currentTask), 200));
    } else {
     return super.get(url, headers: headers);
    }
  }


  @override
  Future<Response> post(url, {Map<String, String> headers, body, Encoding encoding}) {
    printLabel('post url:$url', 'Client');
    printLabel('body:$body', 'Client');
    final request = requestsMap[url];
    if (request != null) {
      return Future.delayed(Duration(seconds: 1), () async => http.Response(await request.getStringResponse(context, url, 'post', currentTask, body), 200));
    }
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    var client = Client();
    try {
      return client.send(request);
    } finally {
      client.close();
    }
  }

}

enum DemoTasks {
  pickupFromClientPu,
  pickupFromClient,
  deliverToClient,
  laundromatPickup,
  laundromatPickupPu,
  laundromatDropoff,
  laundromatDropoffPu,
  gotoLocation,
  batched
}

extension DemoTasksExtension on DemoTasks {
  static String _value(DemoTasks val) {
    switch (val) {
      case DemoTasks.pickupFromClient:
        return 'Pick Up from Customer\n(Without pickup bags)';
      case DemoTasks.pickupFromClientPu:
        return 'Pick Up from Customer';
      case DemoTasks.deliverToClient:
        return 'Drop Off to Customer';
      case DemoTasks.laundromatPickup:
        return 'Pick Up from Warehouse\n(Without pickup bags)';
      case DemoTasks.laundromatPickupPu:
        return 'Pick Up from Warehouse';
      case DemoTasks.laundromatDropoff:
        return 'Drop Off to Warehouse\n(Without pickup bags)';
      case DemoTasks.laundromatDropoffPu:
        return 'Drop Off to Warehouse';
      case DemoTasks.gotoLocation:
        return 'Go to Location';
      case DemoTasks.batched:
        return 'Batched';
    }
  }
  String get value => _value(this);
}