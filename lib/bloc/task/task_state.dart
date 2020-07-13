part of 'task_bloc.dart';

@immutable
abstract class TaskState extends Equatable {
  final Task task;

  TaskState(this.task);
  @override
  List<Object> get props => [task];
}

class WaitingTaskState extends TaskState {
  WaitingTaskState({Task task}) : super(task);
}

class ReadyTaskState extends TaskState {
  final bool switchToNewTask;

  ReadyTaskState(Task task, {this.switchToNewTask = false}) : super(task);

  @override
  List<Object> get props => super.props + [switchToNewTask];
}
