import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'demo_response.dart';


class DemoHttpClient extends BaseClient {

  final requestsMap = <String, DemoResponse>{
    '$servicesUrl/delivery/v2/shift/getShiftDetails/': DemoResponse('assets/mock/regular-business/shift_getShiftDetails.json'),
    '$servicesUrl/delivery/v2/courier/getCourierProfile/':DemoResponse('assets/mock/regular-business/courier_getCourierProfile.json'),

    // Shifts
    '$servicesUrl/delivery/v2/shift/getShiftTypes/': DemoResponse('assets/mock/regular-business/shift_getShiftTypes.json'),
    '$servicesUrl/delivery/v2/shift/getShifts/': DemoResponse('assets/mock/regular-business/shift_getShifts.json'),
    '$servicesUrl/delivery/v2/shift/getUpcomingShifts/': DemoResponse('assets/mock/regular-business/shift_getUpcomingShifts.json'),
  };

  final BuildContext context;

  DemoHttpClient(this.context);

  @override
  Future<Response> get(url, {Map<String, String> headers}) {
    final request = requestsMap[url];
    if (request != null) {
      return Future.delayed(Duration(seconds: 1), () async => http.Response(await DefaultAssetBundle.of(context).loadString(request.assetPath), 200));
    } else {
     return super.get(url, headers: headers);
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
