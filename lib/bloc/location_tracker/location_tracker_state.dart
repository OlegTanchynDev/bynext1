part of 'location_tracker_bloc.dart';

@immutable
abstract class LocationTrackerState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialLocationTrackerState extends LocationTrackerState {}

class OnUpdateLocationTrackerState extends LocationTrackerState {
  final Position position;

  OnUpdateLocationTrackerState(this.position);

  @override
  List<Object> get props => [position];
}