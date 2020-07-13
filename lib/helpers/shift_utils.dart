import 'package:bynextcourier/bloc/shift_details_bloc.dart';
import 'package:flutter/material.dart';

import '../router.dart';
import 'utils.dart';

class ShiftUtils {
  static void shouldSignContractListener(context, shiftDetailsState) {
    if (shiftDetailsState is ShiftDetailsReady) {
      final shift = shiftDetailsState.current;
      printLabel('shift:$shift', 'WelcomeScreen');
      if (shift.contractSignedOnDate == null) {
        printLabel('contractSignedOnDate is NULL', 'WelcomeScreen');
        Navigator.of(context).pushNamed(webRoute,
            arguments: {'url': shift.contractUrl, 'title': 'Terms of Service', 'shouldSignContract': true});
      } else {
        printLabel('contractSignedOnDate is $shift.contractSignedOnDate', 'WelcomeScreen');
      }
    }
  }
}
