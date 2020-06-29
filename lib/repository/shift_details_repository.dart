import 'dart:convert';

import 'package:bynextcourier/model/rest_error.dart';
import 'package:bynextcourier/model/shift.dart';
import 'package:http/http.dart';

import '../constants.dart';

class ShiftDetailsRepository {
  Future<Map<ShiftMode, Shift>> fetchShiftDetails(Client http, String token) async {
    final response = await http.get(
      '$servicesUrl/delivery/v2/shift/getShiftDetails/',
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      final shiftMode = parsed['shift_mode'];
      if ( shiftMode == 'regular/business') {
        return {
          ShiftMode.regular: Shift.fromMap(parsed['regular']),
          ShiftMode.business: Shift.fromMap(parsed['business']),
        };
      } else {
        return { parseShiftModeFromString(shiftMode): Shift.fromMap(parsed)};
      }
    } else {
      throw RestError.fromMap(parsed);
    }
  }
}
