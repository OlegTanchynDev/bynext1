import 'dart:convert';

import 'package:bynextcourier/model/payment.dart';
import 'package:http/http.dart';

import '../constants.dart';

class PaymentRepository {

  Future<Payment> fetchPayment(Client http, String token, [int paymentPeriodId]) async {
    final response = await http.get(
      '$servicesUrl/delivery/v2/payment/' + (paymentPeriodId != null ? "?payment_period_id=$paymentPeriodId" : ""),
      headers: {
        'content-type': 'application/json',
        'Authorization' : "Token $token",
        'Accept-Encoding' : "gzip",
      },
    ).timeout(requestTimeout);

    final parsed = json.decode(response.body);

    if (response.statusCode == 200) {
      return Future.value(Payment.fromMap(parsed));
    } else  {
      return null;
//      throw RestError.fromMap(parsed);
    }
  }
}
