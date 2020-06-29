import 'dart:convert';

import 'package:bynextcourier/model/rest_error.dart';
import 'package:bynextcourier/model/schedule.dart';
import 'package:http/http.dart';

import '../constants.dart';

class ScheduleRepository {
  Future<List<Schedule>> fetchUpcomingShifts(Client http, String token) async {
    final response = await http.get(
      '$servicesUrl/delivery/v2/shift/getUpcomingShifts/',
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return parsed.map<Schedule>((item) => Schedule.fromMap(item)).toList();
    } else {
      throw RestError.fromMap(parsed);
    }
  }
}
