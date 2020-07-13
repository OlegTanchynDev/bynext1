import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/http_client_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:bynextcourier/repository/courier_repository.dart';
import 'package:bynextcourier/repository/tasks_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'task_event.dart';

part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TasksRepository repository;
  CourierRepository courierRepository;
  // ignore: close_sinks
  TokenBloc tokenBloc;
  // ignore: close_sinks
  HttpClientBloc httpClientBloc;

  TaskBloc() : super(WaitingTaskState());

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is GetNextTaskEvent) {
      yield WaitingTaskState();

      final goOnlineResult = await courierRepository.goOnline(httpClientBloc.state.client, tokenBloc.state.token, tokenBloc.state.email);
      if (goOnlineResult) {
        Task task = await repository.fetchNextTask(httpClientBloc.state.client, tokenBloc.state.token,event.shiftId, event.business);
        yield ReadyTaskState(task);
      }
    }
  }
}
