part of 'location_tracker_bloc.dart';

@immutable
abstract class LocationTrackerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitAndStartLocationTrackingEvent extends LocationTrackerEvent {}
class StartLocationTrackingEvent extends LocationTrackerEvent {}
class StopLocationTrackingEvent extends LocationTrackerEvent {}

class OnUpdateLocationEvent extends LocationTrackerEvent {
  final location;
  final userArrivedAtDestinationLocation;

  OnUpdateLocationEvent(this.location, this.userArrivedAtDestinationLocation);
}
