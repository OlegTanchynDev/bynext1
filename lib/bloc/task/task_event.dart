part of 'task_bloc.dart';

@immutable
abstract class TaskEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetNextTaskEvent extends TaskEvent {
  final int shiftId;
  final bool business;

  GetNextTaskEvent(this.shiftId, this.business);

  @override
  List<Object> get props => [shiftId, business];
}

class RefreshTaskEvent extends TaskEvent {}

class TaskUnchangedEvent extends TaskEvent {}

class TaskChangedEvent extends TaskEvent {}

class CompleteTaskEvent extends TaskEvent {}
