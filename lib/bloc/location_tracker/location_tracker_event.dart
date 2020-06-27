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

  OnUpdateLocationEvent(this.location);
}
