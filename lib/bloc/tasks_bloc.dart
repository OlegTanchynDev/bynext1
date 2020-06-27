import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/shift_details_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:bynextcourier/repository/tasks_repository.dart';
import 'package:equatable/equatable.dart';

class TasksListBloc extends Bloc<TasksListEvent, TasksListState> {
  TokenBloc tokenBloc;
  ShiftDetailsBloc _shiftDetailsBloc;
  TasksRepository repository;

  StreamSubscription<ShiftDetailsState> _shiftDetailsSubscription;

  set shiftDetailsBloc(ShiftDetailsBloc value) {
    if (_shiftDetailsBloc != value) {
      _shiftDetailsBloc = value;
      _shiftDetailsSubscription?.cancel();
      _shiftDetailsSubscription = _shiftDetailsBloc.listen((shiftDetailsState) {
        if (shiftDetailsState is ShiftDetailsReady) {
          add(TasksListLoad(shiftDetailsState.current.id));
        }
      });
    }
  }


  @override
  Future<void> close() {
    _shiftDetailsSubscription?.cancel();
    return super.close();
  }

  @override
  TasksListState get initialState => TasksListUninitialized();

  @override
  Stream<TasksListState> mapEventToState(TasksListEvent event) async* {
    if (event is TasksListLoad) {
      yield* _mapLoadToState(event);
    }
  }

  Stream<TasksListState> _mapLoadToState(TasksListLoad event) async* {
    yield TasksListLoading();

    final tasks = await repository.fetchTasks(tokenBloc.state?.token, event.shiftId);

    yield TasksListReady(tasks);
  }
}

// Events
abstract class TasksListEvent extends Equatable {}

class TasksListLoad extends TasksListEvent {
  final int shiftId;

  TasksListLoad(this.shiftId);

  @override
  List<Object> get props => [shiftId];
}

// States
abstract class TasksListState extends Equatable {
  @override
  List<Object> get props => [];
}

class TasksListUninitialized extends TasksListState {}

class TasksListLoading extends TasksListState {}

class TasksListReady extends TasksListState {
  final List<Task> tasks;

  TasksListReady(this.tasks);

  @override
  List<Object> get props => [...tasks];
}
