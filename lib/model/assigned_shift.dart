enum AssignedShiftStatus {
  not_assigned, pending, assigned, cancelled, cancelledByDispatcher
}

AssignedShiftStatus parseAssignedShiftStatusFromInt(int value) {
  print('parseAssignedShiftStatusFromInt $value');
  switch(value) {
    case -1:
      return AssignedShiftStatus.not_assigned;
    case 0:
      return AssignedShiftStatus.pending;
    case 1:
      return AssignedShiftStatus.assigned;
    case 2:
      return AssignedShiftStatus.cancelled;
    case 5:
      return AssignedShiftStatus.cancelledByDispatcher;
    default:
      return AssignedShiftStatus.not_assigned;
  }
}

class AssignedShift {
  final AssignedShiftStatus status;
  final String actualEndTime;
  final bool lessThen24h;
  final String actualStartTime;
  final int shiftId;
  final bool canChange;

  AssignedShift({
    this.status,
    this.actualEndTime,
    this.lessThen24h,
    this.actualStartTime,
    this.shiftId,
    this.canChange,
  });

  factory AssignedShift.fromMap(Map<String, dynamic> map) => AssignedShift(
    status: parseAssignedShiftStatusFromInt(map['status'] as int),
    actualEndTime: map['actual_end_time'] as String,
    lessThen24h: map['is_less_then_24h'],
    actualStartTime: map['actual_start_time'] as String,
    shiftId: map['shift_id'] as int,
    canChange:  map['can_change'] as bool,
  );
}
