import 'dart:convert';

import 'package:bynextcourier/model/rest_error.dart';
import 'package:http/http.dart';
import 'package:bynextcourier/model/queued_task.dart';
import '../constants.dart';

class QueuedTasksRepository {
  Future<List<QueuedTask>> fetchTasks(Client http, String token, int shiftId) async {
    final response = await http.get(
      '$servicesUrl/delivery/v2/tasks/getTaskQueue/?shift_id=$shiftId',
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return parsed.map<QueuedTask>((item) => QueuedTask.fromMap(item)).toList();
    } else {
      throw RestError.fromMap(parsed);
    }
  }
}
