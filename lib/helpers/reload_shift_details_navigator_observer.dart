import 'package:bynextcourier/bloc/shift_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReloadShiftDetailsNavigatorObserver extends NavigatorObserver {
  final BuildContext context;

  ReloadShiftDetailsNavigatorObserver(this.context);

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    // reload when back to home screen
    if (previousRoute.settings.name == '/') {
      BlocProvider.of<ShiftDetailsBloc>(context).add(ShiftDetailsReload());
    }
  }
}