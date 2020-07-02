import 'dart:convert';

import 'package:bynextcourier/model/rest_error.dart';
import 'package:bynextcourier/model/task.dart';
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

    if (response.statusCode == 200) {
      return Task.fromMap(parsed);
    } else {
      throw RestError.fromMap(parsed);
    }
  }
}