import 'dart:convert';

import 'package:bynextcourier/model/rest_error.dart';
import 'package:bynextcourier/model/token.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class TokenRepository {

  Future<Token> login(String login, String password) async {
    final response = await http.post(
      '$servicesUrl/account/api-token-auth/',
      headers: {'content-type': 'application/json'},
      body: json.encode({'username': login ?? '', 'password': password ?? ''}),
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return Future.value(Token.fromMap(parsed));
    } else  {
      throw RestError.fromMap(parsed);
    }
  }

  Future<bool> validateCourierLogin(String login, String version, String token) async {
    final response = await http.get(
      '$servicesUrl/delivery/v2/courier/validateCourierLogin/?appv=$version&email=$login',
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Token $token',
        'Accept-Encoding': 'gzip',
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return Future.value(true);
    } else  {
      return Future.value(false);
//      List<RestError> errors = parsed['errors'].map<RestError>((map) =>
//        RestError.fromJson(map)).toList();
//      throw RestException(cause: errors.first);
    }
  }

  Future<bool> resetPassword(String login) async {
    final response = await http.get(
      '$servicesUrl/account/forgetPassword/?email=$login',
      headers: {
        'content-type': 'application/json',
      },
    ).timeout(requestTimeout);

    var parsed = json.decode(response.body);

    if (parsed['status_code'] == 0) {
      return Future.value(true);
    } else {
      RestError restError = RestError(errors: {});
//      switch (parsed['status_code']) {
//        case 1:
          restError.errors.putIfAbsent('non_field_errors', () => 'Error processing request.');
//      }
      throw restError;
    }
  }
}
