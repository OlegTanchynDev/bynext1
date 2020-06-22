import 'dart:convert';

import 'package:alice/alice.dart';
import 'package:bynextcourier/model/rest_error.dart';
import 'package:bynextcourier/model/token.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class TokenRepository {
  final Alice alice;
  TokenRepository({this.alice});

  Future<Token> login(String login, String password) async {
    final response = await http.post(
      '$servicesUrl/account/api-token-auth/',
      headers: {'content-type': 'application/json'},
      body: json.encode({'username': login ?? '', 'password': password ?? ''}),
    ).timeout(requestTimeout);
    alice.onHttpResponse(response);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return Future.value(Token.fromJson(parsed));
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
    alice.onHttpResponse(response);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return Future.value(true);
    } else  {
//      List<RestError> errors = parsed['errors'].map<RestError>((map) =>
//        RestError.fromJson(map)).toList();
//      throw RestException(cause: errors.first);
    }
  }
}
