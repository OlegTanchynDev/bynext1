import 'dart:convert';

import 'package:bynextcourier/model/issue.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class IssueRepository {

  Future<List> fetchIssues(String token) async {
    final response = await http.get(
      '$servicesUrl/delivery/v2/issues/courier/',
      headers: {
        'content-type': 'application/json',
        'Authorization' : "Token $token",
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);
    List<Issue> issues = (parsed['data'] as List).map((e) => Issue.fromMap(e)).toList();

    if (response.statusCode == 200) {
      return Future.value(issues);
    } else  {
      return null;
//      throw RestError.fromMap(parsed);
    }
  }
}
