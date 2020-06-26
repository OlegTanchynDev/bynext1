class Schedule {
  final String date;
  final String dayName;
  final List<ShiftInfo> shiftInfos;

  Schedule({this.date, this.dayName, this.shiftInfos});

  factory Schedule.fromMap(Map<String, dynamic> map) => Schedule(
      date: map['date'] as String,
      dayName: map['day_name'] as String,
      shiftInfos: map['shifts'].map<ShiftInfo>((item) => ShiftInfo.fromMap(item)).toList());
}

class ShiftInfo {
  final String id;
  final String type;
  final String startHour;
  final String endHour;
  final bool editAllowed;

  ShiftInfo({this.id, this.type, this.startHour, this.endHour, this.editAllowed});

  factory ShiftInfo.fromMap(Map<String, dynamic> map) => ShiftInfo(
        id: map['shift_id'] as String,
        type: map['shift_type'] as String,
        startHour: map['start_hour'] as String,
        endHour: map['end_hour'] as String,
        editAllowed: map['is_edit_allowed'] as bool,
      );
}
