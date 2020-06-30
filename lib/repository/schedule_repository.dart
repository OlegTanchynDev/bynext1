import 'dart:convert';

import 'package:bynextcourier/model/assigned_shift.dart';
import 'package:bynextcourier/model/rest_error.dart';
import 'package:bynextcourier/model/schedule.dart';
import 'package:bynextcourier/model/shift_type.dart';
import 'package:http/http.dart';

import '../constants.dart';

class ScheduleRepository {
  Future<List<Schedule>> fetchUpcomingShifts(Client http, String token, Map<int, ShiftType> shiftTypesMap) async {
    final response = await http.get(
      '$servicesUrl/delivery/v2/shift/getUpcomingShifts/',
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return parsed.map<Schedule>((item) => Schedule.fromMap(item, shiftTypesMap)).toList();
    } else {
      throw RestError.fromMap(parsed);
    }
  }

  Future<List<AssignedShift>> fetchAssignedShifts(Client http, String token) async {
    final response = await http.get(
      '$servicesUrl/delivery/v2/shift/getShifts/',
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return parsed.map<AssignedShift>((item) => AssignedShift.fromMap(item)).toList();
    } else {
      throw RestError.fromMap(parsed);
    }
  }

  Future<List<ShiftType>> fetchShiftTypes(Client http, String token) async {
    final response = await http.get(
      '$servicesUrl/delivery/v2/shift/getShiftTypes/',
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return parsed.map<ShiftType>((item) => ShiftType.fromMap(item)).toList();
    } else {
      throw RestError.fromMap(parsed);
    }
  }

  Future<bool> askShifts(Client http, String token, List<UpcomingShift> shifts) async {
    final response = await http.post(
      '$servicesUrl/delivery/v2/shift/askShifts/',
      headers: {
        'content-type': 'application/json',
        'Authorization': "Token $token",
      },
      body: json.encode({'shifts': shifts.map((shift) => shift.toMap()).toList()}),
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return int.tryParse(parsed['status_code'] ?? '') == 0;
    } else {
      throw RestError.fromMap(parsed);
    }
  }

  Future<void> cancelShift(Client http, String token, int shiftId, String reason) async {
    final params = <String, dynamic>{'shift_id': shiftId};
    if (reason.trim().length > 0) {
      params['cancel_reason'] = reason;
    }

    final response = await http
        .post('$servicesUrl/delivery/v2/shift/cancelShiftRequest/',
            headers: {
              'content-type': 'application/json',
              'Authorization': "Token $token",
            },
            body: json.encode(params))
        .timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return int.tryParse(parsed['status_code'] ?? '') == 0;
    } else {
      throw RestError.fromMap(parsed);
    }
  }
}
