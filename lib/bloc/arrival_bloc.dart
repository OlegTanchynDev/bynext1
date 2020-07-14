import 'package:bynextcourier/model/task.dart';
import 'package:bynextcourier/repository/tasks_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'http_client_bloc.dart';
import 'location_tracker/location_tracker_bloc.dart';
import 'task/task_bloc.dart';
import 'token_bloc.dart';

class ArrivalBloc extends Bloc<ArrivalEvent, ArrivalState> {
  TasksRepository repository;

  // ignore: close_sinks
  TaskBloc taskBloc;

  // ignore: close_sinks
  HttpClientBloc httpClientBloc;

  // ignore: close_sinks
  TokenBloc tokenBloc;

  // ignore: close_sinks
  LocationTrackerBloc locationTrackerBloc;

  ArrivalBloc() : super(ArrivalState(null, false));

  @override
  Stream<ArrivalState> mapEventToState(ArrivalEvent event) async* {
    switch (event.runtimeType) {
      case ArrivedAtPlaceEvent:
        yield* _mapArrivedAtPlaceToState(event);
        break;
      case ArrivalClearEvent:
        yield ArrivalState(null, false);
        break;
    }
  }

  Stream<ArrivalState> _mapArrivedAtPlaceToState(ArrivalEvent event) async* {
    final location = locationTrackerBloc.state.location;
    final task = taskBloc.state.task;
    final result = await repository.performArriveAtPlaceWithTaskID(
        httpClientBloc.state.client,
        tokenBloc.state.token,
        task.id,
        httpClientBloc.state.demo ? null : location.latitude,
        httpClientBloc.state.demo ? null : location.longitude);
    yield ArrivalState(task, result ?? false);
  }
}

// Events
abstract class ArrivalEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ArrivedAtPlaceEvent extends ArrivalEvent {}

class ArrivalClearEvent extends ArrivalEvent {}

// Stated
class ArrivalState extends Equatable {
  final Task task;
  final bool arrived;

  ArrivalState(this.task, this.arrived);

  @override
  List<Object> get props => [task, arrived];
}
