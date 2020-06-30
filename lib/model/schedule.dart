import 'package:equatable/equatable.dart';

import 'shift_type.dart';

class Schedule {
  final String date;
  final String dayName;
  final List<UpcomingShift> shifts;

  Schedule({this.date, this.dayName, this.shifts});

  factory Schedule.fromMap(Map<String, dynamic> map, Map<int, ShiftType> shiftTypesMap) {
    final List<UpcomingShift> upcomingShifts =
        map['shifts'].map<UpcomingShift>((item) => UpcomingShift.fromMap(item, shiftTypesMap)).toList();
    upcomingShifts.sort((a, b) => a.type.id.compareTo(b.type.id));
    return Schedule(date: map['date'] as String, dayName: map['day_name'] as String, shifts: upcomingShifts);
  }
}

class UpcomingShift extends Equatable {
  final int id;
  final ShiftType type;
  final String startHour;
  final String endHour;
  final bool editAllowed;

  UpcomingShift({this.id, this.type, this.startHour, this.endHour, this.editAllowed});

  factory UpcomingShift.fromMap(Map<String, dynamic> map, Map<int, ShiftType> shiftTypesMap) {
    int shiftTypeId = int.tryParse(map['shift_type'] as String ?? '');

    return UpcomingShift(
      id: int.tryParse(map['shift_id'] as String ?? ''),
      type: shiftTypesMap != null ? shiftTypesMap[shiftTypeId] : null,
      startHour: map['start_hour'] as String,
      endHour: map['end_hour'] as String,
      editAllowed: map['is_edit_allowed'] as bool,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'shift_id': id.toString(),
        'start_hour': startHour,
        'end_hour': endHour,
      };

  @override
  List<Object> get props => [id];
}
