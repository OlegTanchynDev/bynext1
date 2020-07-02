import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/http_client_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:bynextcourier/repository/tasks_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'start_job_event.dart';

part 'start_job_state.dart';

class StartJobBloc extends Bloc<StartJobEvent, StartJobState> {
  TasksRepository repository;
  TokenBloc tokenBloc;
  HttpClientBloc httpClientBloc;

  @override
  StartJobState get initialState => WaitingStartJobState();

  @override
  Stream<StartJobState> mapEventToState(StartJobEvent event) async* {
    if (event is GetNextTaskEvent) {
      yield WaitingStartJobState();
      Task task = await repository.fetchNextTask(httpClientBloc.state.client, tokenBloc.state.token,event.shiftId, event.business);
      yield ReadyToStartJobState(task);
    }
  }
}
