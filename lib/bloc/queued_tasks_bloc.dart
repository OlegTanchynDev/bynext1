import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/shift_details_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/model/queued_task.dart';
import 'package:bynextcourier/repository/queued_tasks_repository.dart';
import 'package:equatable/equatable.dart';

import 'http_client_bloc.dart';

class QueuedTasksListBloc extends Bloc<QueuedTasksListEvent, QueuedTasksListState> {
  // ignore: close_sinks
  TokenBloc tokenBloc;
  ShiftDetailsBloc _shiftDetailsBloc;
  QueuedTasksRepository repository;
  // ignore: close_sinks
  HttpClientBloc httpClientBloc;

  StreamSubscription<ShiftDetailsState> _shiftDetailsSubscription;

  QueuedTasksListBloc() : super(QueuedTasksListUninitialized());

  set shiftDetailsBloc(ShiftDetailsBloc value) {
    if (_shiftDetailsBloc != value) {
      _shiftDetailsBloc = value;
      _shiftDetailsSubscription?.cancel();
      _shiftDetailsSubscription = _shiftDetailsBloc.listen((shiftDetailsState) {
        if (shiftDetailsState is ShiftDetailsReady) {
          add(QueuedTasksListLoad(shiftDetailsState.current.id));
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
  Stream<QueuedTasksListState> mapEventToState(QueuedTasksListEvent event) async* {
    if (event is QueuedTasksListLoad) {
      yield* _mapLoadToState(event);
    }
  }

  Stream<QueuedTasksListState> _mapLoadToState(QueuedTasksListLoad event) async* {
    yield QueuedTasksListLoading();

    final tasks = await repository.fetchTasks(httpClientBloc.state.client, tokenBloc.state?.token, event.shiftId);

    yield QueuedTasksListReady(tasks);
  }
}

// Events
abstract class QueuedTasksListEvent extends Equatable {}

class QueuedTasksListLoad extends QueuedTasksListEvent {
  final int shiftId;

  QueuedTasksListLoad(this.shiftId);

  @override
  List<Object> get props => [shiftId];
}

// States
abstract class QueuedTasksListState extends Equatable {
  @override
  List<Object> get props => [];
}

class QueuedTasksListUninitialized extends QueuedTasksListState {}

class QueuedTasksListLoading extends QueuedTasksListState {}

class QueuedTasksListReady extends QueuedTasksListState {
  final List<QueuedTask> tasks;

  QueuedTasksListReady(this.tasks);

  @override
  List<Object> get props => [...tasks];
}
