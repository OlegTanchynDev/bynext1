part of 'task_bloc.dart';

@immutable
abstract class TaskState extends Equatable {
  @override
  List<Object> get props => [];
}

class WaitingTaskState extends TaskState {}

class ReadyTaskState extends TaskState {
  final Task task;
  final bool switchToNewTask;

  ReadyTaskState(this.task, {this.switchToNewTask = false});

  @override
  List<Object> get props => [task, switchToNewTask];
}
