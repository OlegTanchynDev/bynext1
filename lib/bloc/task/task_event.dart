part of 'task_bloc.dart';

@immutable
abstract class TaskEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetNextTaskEvent extends TaskEvent {}

// called by timer, shiftDetails changed
class RefreshTaskEvent extends TaskEvent {}

// called to allow RefreshTaskEvent again
class TaskUnchangedEvent extends TaskEvent {}

// called to allow RefreshTaskEvent again
class TaskChangedEvent extends TaskEvent {}

class CompleteTaskEvent extends TaskEvent {}

class ClearTaskEvent extends TaskEvent {}
