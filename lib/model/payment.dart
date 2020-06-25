class Payment {
  const Payment({
    this.paymentPeriods,
    this.numberOfShifts,
    this.currentPaymentPeriod,
    this.totalPayment,
    this.shiftsDetails,
    this.rateSystem,
    this.extras,
    this.extrasDetails,
    this.paymentDetailsJson,
  });

  final List<PaymentPeriod> paymentPeriods;
  final int numberOfShifts;
  final PaymentPeriod currentPaymentPeriod;
  final num totalPayment;
  final List shiftsDetails;
  final int rateSystem;
  final int extras;
  final List extrasDetails;
  final paymentDetailsJson;



  static final String _keyPaymentPeriods = "payment_periods";
  static final String _keyNumberOfShifts = "number_of_shifts";
  static final String _keyCurrentPaymentPeriod = "current_payment_period";
  static final String _keyTotalPayment = "total_payment";
  static final String _keyShiftsDetails = "shifts_details";
  static final String _keyRateSystem = "rate_system";
  static final String _keyExtras = "extras";
  static final String _keyExtrasDetails = "extras_details";
  static final String _keyPaymentDetailsJson = "payment_details_json";

  Map<String, dynamic> toMap() =>
    <String, dynamic>{
      _keyPaymentPeriods: paymentPeriods,
      _keyNumberOfShifts: numberOfShifts,
      _keyCurrentPaymentPeriod: currentPaymentPeriod,
      _keyTotalPayment: totalPayment,
      _keyShiftsDetails: shiftsDetails,
      _keyRateSystem: rateSystem,
      _keyExtras: extras,
      _keyExtrasDetails: extrasDetails,
      _keyPaymentDetailsJson: paymentDetailsJson,
    };

  factory Payment.fromMap(Map<String, dynamic> map) {
    final p_periods = (map[_keyPaymentPeriods] as List).map((e) => PaymentPeriod.fromMap(e)).toList();
    final c_p_period = PaymentPeriod.fromMap(map[_keyCurrentPaymentPeriod]);

    return Payment(
      paymentPeriods: p_periods,
      numberOfShifts: map[_keyNumberOfShifts] as int,
      currentPaymentPeriod: c_p_period,
      totalPayment: map[_keyTotalPayment] as num,
      shiftsDetails: map[_keyShiftsDetails] as List,
      rateSystem: map[_keyRateSystem] as int,
      extras: map[_keyExtras] as int,
      extrasDetails: map[_keyExtrasDetails] as List,
      paymentDetailsJson: map[_keyPaymentDetailsJson],
    );
  }
}

class PaymentPeriod{
  final int id;
  final int rateSystem;
  final String name;

  PaymentPeriod({this.id, this.rateSystem, this.name});

  static final String _keyId = "id";
  static final String _keyRateSystem = "rate_system";
  static final String _keyName = "name";

  factory PaymentPeriod.fromMap(Map<String, dynamic> map) =>
    PaymentPeriod(
      id: map[_keyId] as int,
      rateSystem: map[_keyRateSystem] as int,
      name: map[_keyName] as String,
    );

  Map<String, dynamic> toMap() =>
    <String, dynamic>{
      _keyId: id,
      _keyRateSystem: rateSystem,
      _keyName: name,
    };
}
