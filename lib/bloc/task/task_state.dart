part of 'task_bloc.dart';

@immutable
abstract class TaskState extends Equatable {
  @override
  List<Object> get props => [];
}

class WaitingTaskState extends TaskState {}

class ReadyTaskState extends TaskState {
  final Task task;

  ReadyTaskState(this.task);

  @override
  List<Object> get props => [task];
}
