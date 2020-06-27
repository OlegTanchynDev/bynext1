part of 'location_tracker_bloc.dart';

@immutable
class LocationTrackerBaseState extends Equatable {
  final bool isServiceRunning;
  final LocationDto location;

  LocationTrackerBaseState(this.isServiceRunning, this.location);

  @override
  List<Object> get props => [isServiceRunning, location];
}

class InitialLocationTrackerState extends LocationTrackerBaseState {
  InitialLocationTrackerState() : super(false, null);
}

class LocationTrackerState extends LocationTrackerBaseState {
  LocationTrackerState(bool isServiceRunning, LocationDto location) : super(isServiceRunning, location);
}