import 'dart:convert';

import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/model/rest_error.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:http/http.dart';

import '../constants.dart';

class TasksRepository {
  Future<Task> fetchNextTask(Client http, String token, int shiftId, bool business) async {
    final response = await http.get(
      '$servicesUrl/delivery/v2/tasks/getTask/?${business ? 'route_id' : 'shift_id'}=$shiftId',
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

  Future<bool> performArriveAtPlaceWithTaskID(Client http, String token, num taskId, [num lat, num lng]) async {
    print('$servicesUrl/delivery/v2/location/arriveAtPlace?taskId=$taskId&lat=$lat&lng=$lng');

    final response = await http.get(
      '$servicesUrl/delivery/v2/location/arriveAtPlace?taskId=$taskId&lat=$lat&lng=$lng',
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
        'Accept-Encoding': 'gzip',
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);
    printLabel('performArriveAtPlaceWithTaskID:$parsed', 'TasksRepository');

    if (response.statusCode == 200) {
      return int.tryParse(parsed['status_code'] ?? '-1') == 0;
    } else {
      throw RestError.fromMap(parsed);
    }
  }

  Future<num> getTaskReward(Client http, String token, num taskId) async {
    print('$servicesUrl/delivery/v2/tasks/completeTask/?task_id=$taskId');

    final response = await http.get(
      '$servicesUrl/delivery/v2/tasks/completeTask/?task_id=$taskId',
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
        'Accept-Encoding': 'gzip',
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);
    printLabel('performCompleteWithTaskID:$parsed', 'TasksRepository');

    if (response.statusCode == 200) {
      return (parsed['data'])['pay_for_run'] ?? -1;
    } else {
      throw RestError.fromMap(parsed);
    }
  }

}
