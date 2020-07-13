import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/http_client_bloc.dart';
import 'package:bynextcourier/bloc/shift_details_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:bynextcourier/repository/courier_repository.dart';
import 'package:bynextcourier/repository/tasks_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'ticker.dart';

part 'task_event.dart';

part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final Ticker _ticker = Ticker();
  static const int _duration = 10; //check Task period interval (seconds)
  StreamSubscription<void> _tickerSubscription;
  ShiftDetailsBloc _shiftDetailsBloc;

  StreamSubscription<ShiftDetailsState> _shiftDetailsSubscription;

  set shiftDetailsBloc(ShiftDetailsBloc value) {
    if (_shiftDetailsBloc != value) {
      _shiftDetailsBloc = value;
      _shiftDetailsSubscription = _shiftDetailsBloc.listen((shiftDetailsState) {
        add(RefreshTaskEvent());
      });
    }
  }

  TasksRepository repository;
  CourierRepository courierRepository;

  // ignore: close_sinks
  TokenBloc tokenBloc;

  // ignore: close_sinks
  HttpClientBloc httpClientBloc;

  TaskBloc() : super(WaitingTaskState());

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    _shiftDetailsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    switch (event.runtimeType) {
      case GetNextTaskEvent:
        yield* _mapGetNextTaskToState(event);
        break;
      case RefreshTaskEvent:
        yield* _mapRefreshTaskTimerToState(event);
        break;
      case ClearTaskEvent:
        yield* _mapClearToState();
        break;
    }
  }

  Stream<TaskState> _mapGetNextTaskToState(GetNextTaskEvent event) async* {
    yield WaitingTaskState(task: state.task);

    final shiftDetailsState = _shiftDetailsBloc.state;
    final goOnlineResult =
        await courierRepository.goOnline(httpClientBloc.state.client, tokenBloc.state.token, tokenBloc.state.email);
    if (goOnlineResult && shiftDetailsState is ShiftDetailsReady) {
      Task task = await repository.fetchNextTask(httpClientBloc.state.client, tokenBloc.state.token,
          shiftDetailsState.current.id, shiftDetailsState.isBusiness);
      yield ReadyTaskState(task);

      _tickerSubscription?.cancel();
      _tickerSubscription = _ticker.tick(period: _duration).listen((_) => add(RefreshTaskEvent()));
    }
  }

  Stream<TaskState> _mapRefreshTaskTimerToState(RefreshTaskEvent event) async* {
    final shiftDetailsState = _shiftDetailsBloc.state;
    final currentTaskState = state;
    if (currentTaskState is ReadyTaskState && shiftDetailsState is ShiftDetailsReady) {
      final Task task = await repository.fetchNextTask(httpClientBloc.state.client, tokenBloc.state.token,
          shiftDetailsState.current.id, shiftDetailsState.isBusiness);

      if (task.id != currentTaskState.task.id || task.contact?.phone != currentTaskState.task.contact?.phone) {
        if ((task.linkedTasks?.length ?? 0) > 0) {
          if (task.linkedTasks.where((t) => t.id == task.id).length == 0) {
            yield ReadyTaskState(task, switchToNewTask: true);
          }
        } else {
          yield ReadyTaskState(task, switchToNewTask: true);
        }
        add(TaskChangedEvent());
      } else if (task.noShowEnabled != currentTaskState.task.noShowEnabled ||
          task.meta?.isBusinessAccount != currentTaskState.task.meta?.isBusinessAccount) {
        yield ReadyTaskState(task, switchToNewTask: false);
        add(TaskChangedEvent());
      } else {
        add(TaskUnchangedEvent());
      }
    }
  }

  Stream<TaskState> _mapClearToState() async* {
    yield WaitingTaskState();
  }
}
