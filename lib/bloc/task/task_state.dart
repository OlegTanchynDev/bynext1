part of 'task_bloc.dart';

@immutable
abstract class TaskState extends Equatable {
  @override
  List<Object> get props => [];
}

class WaitingStartJobState extends TaskState {}

class ReadyToStartJobState extends TaskState {
  final Task task;

  ReadyToStartJobState(this.task);

  @override
  List<Object> get props => [task];
}
