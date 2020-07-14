import 'dart:collection';
import 'dart:convert';

import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/model/rest_error.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../constants.dart';

class DriverChatRepository {
  Future<dynamic> performGetFirebaseAuthSuccessBlock(Client http, String token, int taskId) async {
    final response = await http.get(
      '$servicesUrl/delivery/v2/chat/token/?task_id=$taskId',
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
        'Accept-Encoding': 'gzip',
      },
    ).timeout(requestTimeout);
    printLabel('response.body:${response.body}', 'DriverChatRepository');
    final parsed = json.decode(response.body);
    printLabel('performGetFirebaseAuthSuccessBlock:$parsed', 'DriverChatRepository');
    if (response.statusCode == 200) {
      return parsed;
    } else {
      throw RestError.fromMap(parsed);
    }
  }

}
