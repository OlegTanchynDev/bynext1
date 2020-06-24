import 'dart:convert';

import 'package:bynextcourier/model/profile.dart';
import 'package:bynextcourier/model/rest_error.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class ProfileRepository {

  Future<Profile> fetchProfile(String token) async {
    final response = await http.get(
      '$servicesUrl/delivery/v2/courier/getCourierProfile/',
      headers: {
        'content-type': 'application/json',
        'Authorization' : "Token $token",
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return Future.value(Profile.fromMap(parsed));
    } else  {
      throw RestError.fromMap(parsed);
    }
  }
}
