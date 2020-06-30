enum ShiftMode { regular, business }

ShiftMode parseShiftModeFromString(String str) {
  switch (str) {
    case 'regular':
      return ShiftMode.regular;
    case 'business':
      return ShiftMode.business;
    default:
      return null;
  }
}

enum RateSystem {
  DELIVERY_COURIER_PAYMENT_RATE_HOURLY,
  DELIVERY_COURIER_PAYMENT_RATE_FIXED,
  DELIVERY_COURIER_PAYMENT_EMPLOYEE,
  DELIVERY_COURIER_PAYMENT_EMPLOYEE_FIXED_RUN_COST,
  DELIVERY_COURIER_PAYMENT_EMPLOYEE_HIDE_INFO
}

RateSystem parseRateSystemFromInt(int val) {
  switch (val) {
    case 0:
      return RateSystem.DELIVERY_COURIER_PAYMENT_RATE_HOURLY;
    case 1:
      return RateSystem.DELIVERY_COURIER_PAYMENT_RATE_FIXED;
    case 2:
      return RateSystem.DELIVERY_COURIER_PAYMENT_EMPLOYEE;
    case 3:
      return RateSystem.DELIVERY_COURIER_PAYMENT_EMPLOYEE_FIXED_RUN_COST;
    case 4:
      return RateSystem.DELIVERY_COURIER_PAYMENT_EMPLOYEE_HIDE_INFO;
    default:
      return null;
  }
}

//extension ParseToString on ShiftMode {
//  String toShortString() {
//    switch (this) {
//      case ShiftMode.regular:
//        return 'regular';
//      case ShiftMode.business:
//        return 'business';
//      case ShiftMode.regularOrBusiness:
//        return 'regular/business';
//    }
//  }
//}

class Shift {
  final int id;
  final ShiftMode shiftMode;
  final String startLocationName;
  final double startLocationLat;
  final double startLocationLng;
  final DateTime startDateTime;
  final bool canStart;
  final String dispatcherName;
  final String dispatcherPhone;
  final int contractId;
  final String contractUrl;
  final RateSystem contractRateSystem;
  final DateTime contractSignedOnDate;
  final double shiftPayment;

  const Shift({
    this.id,
    this.shiftMode,
    this.startLocationName,
    this.startLocationLat,
    this.startLocationLng,
    this.startDateTime,
    this.canStart,
    this.dispatcherName,
    this.dispatcherPhone,
    this.contractId,
    this.contractUrl,
    this.contractRateSystem,
    this.contractSignedOnDate,
    this.shiftPayment,
  });

  factory Shift.fromMap(Map<String, dynamic> map) {
    final startLocation = map['start_location'];
    final dispatcher = map['dispatcher'];
    final contract = map['contract'];
    return Shift(
      id: map['id'],
      shiftMode: parseShiftModeFromString(map['shift_mode'] as String),
      startLocationName: startLocation != null ? startLocation['name'] : null,
      startLocationLat: startLocation != null ? startLocation['lat'] as double : null,
      startLocationLng: startLocation != null ? startLocation['lng'] as double : null,
      startDateTime: DateTime.tryParse(map['start_datetime'] as String ?? ''),
      canStart: map['can_start_shift'] as bool,
      dispatcherName: dispatcher != null ? dispatcher['name'] as String : null,
      dispatcherPhone: dispatcher != null ? dispatcher['phone'] as String : null,
      contractId: contract != null ? contract['id'] as int : null,
      contractUrl: contract != null ? contract['contract_url'] as String : null,
      contractRateSystem: contract != null ? parseRateSystemFromInt(contract['contract_rate_system'] as int) : null,
      contractSignedOnDate: contract != null ? DateTime.tryParse(contract['signed_on_date'] as String ?? '') : null,
      shiftPayment: map['shift_payment'] as double,
    );
  }
}
