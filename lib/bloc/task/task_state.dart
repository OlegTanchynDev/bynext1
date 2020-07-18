part of 'task_bloc.dart';

@immutable
abstract class TaskState extends Equatable {
  final Task task;
  final Task rootTask;

  TaskState(this.task, this.rootTask);
  @override
  List<Object> get props => [task];
}

class WaitingTaskState extends TaskState {
  WaitingTaskState({Task task, Task rootTask}) : super(task, rootTask);
}

class ReadyTaskState extends TaskState {
  final bool switchToNewTask;

  ReadyTaskState(Task task, {this.switchToNewTask = false, Task batchTask}) : super(task, batchTask);

  @override
  List<Object> get props => super.props + [switchToNewTask];
}

class CompleteTaskState extends ReadyTaskState {
  final num reward;

  CompleteTaskState(Task task, {this.reward}) : super(task);

  @override
  List<Object> get props => super.props + [reward];
}
