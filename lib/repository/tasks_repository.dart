import 'dart:convert';

import 'package:bynextcourier/model/rest_error.dart';
import 'package:http/http.dart' as http;
import 'package:bynextcourier/model/task.dart';
import '../constants.dart';

class TasksRepository {
  Future<List<Task>> fetchTasks(String token, int shiftId) async {
    final response = await http.get(
      '$servicesUrl/delivery/v2/tasks/getTaskQueue/?shift_id=$shiftId',
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return parsed.map<Task>((item) => Task.fromMap(item)).toList();
    } else {
      throw RestError.fromMap(parsed);
    }
  }
}
