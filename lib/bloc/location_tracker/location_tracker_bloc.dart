import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

part 'location_tracker_event.dart';

part 'location_tracker_state.dart';

class LocationTrackerBloc
    extends Bloc<LocationTrackerEvent, LocationTrackerState> {
  @override
  LocationTrackerState get initialState => InitialLocationTrackerState();
  StreamSubscription<Position> _positionStreamSubscription;

  void startLocationTracking() {
    print('startLocationTracking');
    add(StartLocationTrackingEvent());
  }

  void stopLocationTracking() {
    print('stopLocationTracking');
    add(StopLocationTrackingEvent());
  }

  void _onUpdateLocation(Position position) {
    print('_onUpdateLocation ' + position?.toString());
    add(OnUpdateLocationEvent(position));
  }

  @override
  Stream<LocationTrackerState> mapEventToState(
      LocationTrackerEvent event) async* {
    if (event is StartLocationTrackingEvent) {
       _startLocationTrackingEvent();
    }else if (event is StopLocationTrackingEvent) {
      if (_positionStreamSubscription != null && !_positionStreamSubscription.isPaused) {
        _positionStreamSubscription.pause();
      }
    }else if (event is OnUpdateLocationEvent) {
      yield OnUpdateLocationTrackerState(event.position);
    }
  }

  @override
  Future<void> close() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }
    return super.close();
  }

  void _startLocationTrackingEvent() {
    if (_positionStreamSubscription == null) {
      const LocationOptions locationOptions =
          LocationOptions(accuracy: LocationAccuracy.best);
      final Stream<Position> positionStream =
          Geolocator().getPositionStream(locationOptions);
      _positionStreamSubscription = positionStream.listen(_onUpdateLocation);
    }

    if (_positionStreamSubscription.isPaused) {
      _positionStreamSubscription.resume();
    }
  }
}
