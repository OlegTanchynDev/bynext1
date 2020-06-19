import 'dart:convert';

import 'package:alice/alice.dart';
import 'package:bynextcourier/model/oauth_token.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class TokenRepository {
  final Alice alice;
  TokenRepository({this.alice});

  Future<OauthToken> login(String login, String password) async {
    final response = await http.post(
//      '$servicesUrl/oauth2/token',
      '$servicesUrl/account/api-token-auth/',
      headers: {'content-type': 'application/json'},
      body: json.encode({'username': login ?? '', 'password': password ?? ''}),
    ).timeout(requestTimeout);
    alice.onHttpResponse(response);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return Future.value(OauthToken.fromJson(parsed));
    } else if (parsed['errors'] != null) {
//      List<RestError> errors = parsed['errors'].map<RestError>((map) =>
//        RestError.fromJson(map)).toList();
//      throw RestException(cause: errors.first);
    }
  }
}
