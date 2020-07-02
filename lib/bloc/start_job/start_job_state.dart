part of 'start_job_bloc.dart';

@immutable
abstract class StartJobState  extends Equatable {
  @override
  List<Object> get props => [];
}

class WaitingStartJobState extends StartJobState {}
class ReadyToStartJobState extends StartJobState {
  final Task task;

  ReadyToStartJobState(this.task);

  @override
  List<Object> get props => [task];
}