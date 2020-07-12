import 'package:bloc/bloc.dart';
import 'package:bynextcourier/model/assigned_shift.dart';
import 'package:bynextcourier/model/schedule.dart';
import 'package:bynextcourier/model/shift_type.dart';
import 'package:bynextcourier/repository/schedule_repository.dart';
import 'package:equatable/equatable.dart';

import 'http_client_bloc.dart';
import 'token_bloc.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  // ignore: close_sinks
  TokenBloc tokenBloc;
  ScheduleRepository repository;
  // ignore: close_sinks
  HttpClientBloc httpClientBloc;

  @override
  ScheduleState get initialState => ScheduleReady([], {}, [], null, null);

  @override
  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    switch (event.runtimeType) {
      case ScheduleLoad:
        yield* _mapLoadToState(event);
        break;
      case ScheduleUpcomingSelect:
        yield* _mapSelectToState(event);
        break;
      case ScheduleUpcomingDeselect:
        yield* _mapDeselectToState(event);
        break;
      case ScheduleCancelShift:
        yield* _mapCancelToState(event);
        break;
      case ScheduleBlankEvent:
        yield* _mapBlankToState(event);
        break;
      case ScheduleSave:
        yield* _mapSaveToState(event);
        break;
    }
  }

  Stream<ScheduleState> _mapLoadToState(ScheduleLoad event) async* {
    yield ScheduleLoading.from(state);

    final shiftTypes = await repository.fetchShiftTypes(httpClientBloc.state.client, tokenBloc.state?.token);
    final Map<int, ShiftType> shiftTypesMap = Map.fromIterable(shiftTypes, key: (v) => v.id, value: (v) => v);
    final upcoming =
        await repository.fetchUpcomingShifts(httpClientBloc.state.client, tokenBloc.state?.token, shiftTypesMap);
    final assignedItems = await repository.fetchAssignedShifts(httpClientBloc.state.client, tokenBloc.state?.token);

    final Map<int, AssignedShift> assigned = Map.fromIterable(assignedItems, key: (v) => v.shiftId, value: (v) => v);

    yield ScheduleReady(upcoming, assigned, <UpcomingShift>[], null, null);
  }

  Stream<ScheduleState> _mapSelectToState(ScheduleUpcomingSelect event) async* {
    final currentState = state;
    if (currentState is ScheduleReady) {
      final selectedShifts = List.of(currentState.selectedShifts);
      final shift = currentState.assigned[event.upcomingShift.id];

      if (shift != null) {
        if (shift.status != AssignedShiftStatus.cancelled) {
          yield ScheduleReady(
              currentState.upcoming, currentState.assigned, selectedShifts, event.upcomingShift, event.schedule);
        } else {
          // remove Cancelled selection
          if (!selectedShifts.contains(event.upcomingShift)) {
            selectedShifts.add(event.upcomingShift);
            yield ScheduleReady(currentState.upcoming, currentState.assigned, selectedShifts, null, null);
          }
        }
      } else {
        if (!selectedShifts.contains(event.upcomingShift)) {
          selectedShifts.add(event.upcomingShift);

          yield ScheduleReady(currentState.upcoming, currentState.assigned, selectedShifts, null, null);
        }
      }
    }
  }

  Stream<ScheduleState> _mapDeselectToState(ScheduleUpcomingDeselect event) async* {
    final currentState = state;
    if (currentState is ScheduleReady) {
      final selectedShifts = List.of(currentState.selectedShifts);
      if (selectedShifts.contains(event.upcomingShift)) {
        selectedShifts.remove(event.upcomingShift);

        yield ScheduleReady(currentState.upcoming, currentState.assigned, selectedShifts, null, null);
      }
    }
  }

  Stream<ScheduleState> _mapCancelToState(ScheduleCancelShift event) async* {
    await repository.cancelShift(httpClientBloc.state.client, tokenBloc.state?.token, event.shiftId, event.reasonText);
    add(ScheduleLoad());
  }

  Stream<ScheduleState> _mapBlankToState(ScheduleEvent event) async* {
    final currentState = state;
    if (currentState is ScheduleReady) {
      yield ScheduleReady(currentState.upcoming, currentState.assigned, currentState.selectedShifts, null, null);
    }
  }

  Stream<ScheduleState> _mapSaveToState(ScheduleSave event) async* {
    final currentState = state;
    if (currentState is ScheduleReady && currentState.selectedShifts.length > 0) {
      await repository.askShifts(httpClientBloc.state.client, tokenBloc.state?.token, currentState.selectedShifts);
      add(ScheduleLoad());
    }
  }
}

// Events
abstract class ScheduleEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ScheduleLoad extends ScheduleEvent {}

class ScheduleUpcomingSelect extends ScheduleEvent {
  final UpcomingShift upcomingShift;
  final Schedule schedule;

  ScheduleUpcomingSelect(this.upcomingShift, this.schedule);

  @override
  List<Object> get props => [upcomingShift];
}

class ScheduleUpcomingDeselect extends ScheduleEvent {
  final UpcomingShift upcomingShift;
  final Schedule schedule;

  ScheduleUpcomingDeselect(this.upcomingShift, this.schedule);

  @override
  List<Object> get props => [upcomingShift];
}

class ScheduleCancelShift extends ScheduleEvent {
  final int shiftId;
  final String reasonText;

  ScheduleCancelShift(this.shiftId, this.reasonText);

  @override
  List<Object> get props => [shiftId, reasonText];
}

class ScheduleBlankEvent extends ScheduleEvent {}

class ScheduleSave extends ScheduleEvent {}

// States
class ScheduleState extends Equatable {
  final List<Schedule> upcoming;
  final Map<int, AssignedShift> assigned;
  final List<UpcomingShift> selectedShifts;
  final UpcomingShift cancellationShift;
  final Schedule cancellationSchedule;

  ScheduleState(this.upcoming, this.assigned, this.selectedShifts, this.cancellationShift, this.cancellationSchedule);

  @override
  List<Object> get props =>
      [...upcoming, ...assigned.keys, ...assigned.values, ...selectedShifts, cancellationShift, cancellationSchedule];
}

class ScheduleLoading extends ScheduleState {
  ScheduleLoading(List<Schedule> upcoming, Map<int, AssignedShift> assigned, List<UpcomingShift> selectedShifts,
      UpcomingShift cancellationShift, Schedule cancellationSchedule)
      : super(upcoming, assigned, selectedShifts, cancellationShift, cancellationSchedule);

  static ScheduleLoading from(ScheduleState state) {
    return ScheduleLoading(state.upcoming, state.assigned, state.selectedShifts, state.cancellationShift, state.cancellationSchedule);
  }
}

class ScheduleReady extends ScheduleState {
  ScheduleReady(List<Schedule> upcoming, Map<int, AssignedShift> assigned, List<UpcomingShift> selectedShifts,
      UpcomingShift cancellationShift, Schedule cancellationSchedule)
      : super(upcoming, assigned, selectedShifts, cancellationShift, cancellationSchedule);

  bool get cancellationLockedToChanges {
    final shift = assigned[cancellationShift.id];
    return !shift.canChange;
  }
}
