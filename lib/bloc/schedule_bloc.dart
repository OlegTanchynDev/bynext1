import 'package:bloc/bloc.dart';
import 'package:bynextcourier/model/schedule.dart';
import 'package:bynextcourier/repository/schedule_repository.dart';
import 'package:equatable/equatable.dart';

import 'http_client_bloc.dart';
import 'token_bloc.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  TokenBloc tokenBloc;
  ScheduleRepository repository;
  HttpClientBloc httpClientBloc;

  @override
  ScheduleState get initialState => ScheduleUninitialized();

  @override
  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    if (event is ScheduleLoad) {
      yield* _mapLoadToState(event);
    }
  }

  Stream<ScheduleState> _mapLoadToState(ScheduleLoad event) async* {
    yield ScheduleLoading();

    final items = await repository.fetchUpcomingShifts(httpClientBloc.state.client, tokenBloc.state?.token);

    yield ScheduleReady(items);
  }
}

// Events
abstract class ScheduleEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ScheduleLoad extends ScheduleEvent {}

// States
class ScheduleState extends Equatable {
  @override
  List<Object> get props => [];
}

class ScheduleUninitialized extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleReady extends ScheduleState {
  final List<Schedule> items;

  ScheduleReady(this.items);

  @override
  List<Object> get props => [...items];
}
