import 'package:bynextcourier/bloc/arrival_bloc.dart';
import 'package:bynextcourier/bloc/location_tracker/location_tracker_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'animated_button.dart';

class ArrivedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationTrackerBloc, LocationTrackerBaseState>(
      builder: (BuildContext context, LocationTrackerBaseState state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: AnimatedButton(
              child: Text('Arrived at place >>'),
              condition: state.userArrivedAtDestinationLocation,
              onHorizontalDragUpdate: (details) {
                print('onHorizontalDragUpdate = ${details.primaryDelta}');
                if (details.primaryDelta > 40) {
                  context.bloc<ArrivalBloc>().add(ArrivedAtPlaceEvent());
                }
              }),
        );
      },
    );
  }
}
