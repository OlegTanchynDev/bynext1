import 'dart:convert';

import 'package:bynextcourier/model/rest_error.dart';
import 'package:http/http.dart';

import '../constants.dart';

class CourierRepository {
  Future<bool> goOnline(Client http, String token, String email) async {
    final response = await http.get(
      '$servicesUrl/delivery/courier/online/?email=$email',
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return Future.value(true);
    } else {
      throw RestError.fromMap(parsed);
    }
  }

  Future<void> goOffline(Client http, String token, String email) async {
    final response = await http.get(
      '$servicesUrl/delivery/courier/offline/?email=$email',
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return Future.value(null);
    } else {
      throw RestError.fromMap(parsed);
    }
  }
}
