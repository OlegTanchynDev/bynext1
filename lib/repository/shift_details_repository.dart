import 'dart:convert';

import 'package:bynextcourier/model/rest_error.dart';
import 'package:bynextcourier/model/shift.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class ShiftDetailsRepository {
  Future<Shift> fetchShiftDetails(String token) async {
    final response = await http.get(
      '$servicesUrl/delivery/v2/shift/getShiftDetails/',
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return Shift.fromMap(parsed);
    } else {
      throw RestError.fromMap(parsed);
    }
  }
}
