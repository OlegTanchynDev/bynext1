part of 'location_tracker_bloc.dart';

@immutable
class LocationTrackerBaseState extends Equatable {
  final bool isServiceRunning;
  final LocationDto location;
  final bool userArrivedAtDestinationLocation;

  LocationTrackerBaseState(this.isServiceRunning, this.location, this.userArrivedAtDestinationLocation);

  @override
  List<Object> get props => [isServiceRunning, location, userArrivedAtDestinationLocation];
}

class InitialLocationTrackerState extends LocationTrackerBaseState {
  InitialLocationTrackerState() : super(false, null, false);
}

class LocationTrackerState extends LocationTrackerBaseState {
  LocationTrackerState(bool isServiceRunning, LocationDto location, bool userArrivedAtDestinationLocation) : super(isServiceRunning, location, userArrivedAtDestinationLocation);
}