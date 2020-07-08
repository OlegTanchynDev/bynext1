import 'dart:collection';
import 'dart:convert';

import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/model/rest_error.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../constants.dart';

class TasksRepository {
  Future<Task> fetchNextTask(Client http, String token, int shiftId, bool business) async {
    final response = await http.get(
      '$servicesUrl/delivery/v2/tasks/getTask/?&${ business ? 'route_id' : 'shift_id'}=$shiftId',
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);
    printLabel('fetchNextTask:$parsed', 'TasksRepository');
    if (response.statusCode == 200) {
      return Task.fromMap(parsed);
    } else {
      throw RestError.fromMap(parsed);
    }
  }

  Future<dynamic> performArriveAtPlaceWithTaskID(Client http, String token, num taskId, [num lat, num lng]) async {
    Map<String, String> queryParameters = {'taskId':'$taskId'};
    if (lat != null && lng != null) {
      queryParameters['lat'] = '$lat';
      queryParameters['lng'] = '$lng';
    }
    var authority = kDebugMode ? "playground.cleanlyapp.com" : "cleanlyapp.com";
    var uri =
    Uri.https(authority, '/services/delivery/v2/location/arriveAtPlace', queryParameters);
    final response = await http.get(
      uri.toString(),
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
        'Accept-Encoding': 'gzip',
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);
    printLabel('performArriveAtPlaceWithTaskID:$parsed', 'TasksRepository');

    if (response.statusCode == 200) {
      return parsed;
    } else {
      throw RestError.fromMap(parsed);
    }
  }
}