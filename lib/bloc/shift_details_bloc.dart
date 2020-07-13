import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/model/shift.dart';
import 'package:bynextcourier/repository/shift_details_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'http_client_bloc.dart';

class ShiftDetailsBloc extends Bloc<ShiftDetailsEvent, ShiftDetailsState> {
  ShiftDetailsRepository repository;
  TokenBloc _tokenBloc;
  // ignore: close_sinks
  HttpClientBloc httpClientBloc;

  StreamSubscription<TokenState> _tokenBlocSubscription;

  ShiftDetailsBloc() : super(ShiftDetailsUninitialized());

  set tokenBloc(TokenBloc value) {
    if (_tokenBloc != value) {
      _tokenBloc = value;
      _tokenBlocSubscription = _tokenBloc.listen((tokenState) {
        if (tokenState is TokenValid && tokenState.token != null) {
          add(ShiftDetailsLoad());
        }
      });
    }
  }

  @override
  Future<void> close() {
    _tokenBlocSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<ShiftDetailsState> mapEventToState(ShiftDetailsEvent event) async* {
    if (event is ShiftDetailsLoad) {
      yield* _mapLoadToState();
    } else if (event is ShiftDetailsSwitch) {
      yield* _mapSwitchToState(event);
    } else if (event is ShiftDetailsReload) {
      add(ShiftDetailsLoad());
    }
  }

  Stream<ShiftDetailsState> _mapLoadToState() async* {
    yield ShiftDetailsLoading();

    final shiftsMap = await repository.fetchShiftDetails(httpClientBloc.state.client, _tokenBloc.state?.token);

    final prefs = await SharedPreferences.getInstance();
    bool businessShift = prefs.getBool('business') ?? false;

    if (businessShift && shiftsMap[ShiftMode.business] == null && shiftsMap[ShiftMode.regular] != null) {
      businessShift = false;
      prefs.setBool('business', false);
    } else if (!businessShift && shiftsMap[ShiftMode.regular] == null && shiftsMap[ShiftMode.business] != null) {
      businessShift = true;
      prefs.setBool('business', true);
    }

    yield ShiftDetailsReady(shiftsMap[ShiftMode.regular], shiftsMap[ShiftMode.business],
        shiftsMap[businessShift ? ShiftMode.business : ShiftMode.regular]);
  }

  Stream<ShiftDetailsState> _mapSwitchToState(ShiftDetailsSwitch event) async* {
    final currentState = state;
    if (currentState is ShiftDetailsReady) {
      if (event.shiftMode != currentState.current.shiftMode) {
        Shift selectedShift = currentState.current;
        if (event.shiftMode == ShiftMode.regular && currentState.regular != null) {
          selectedShift = currentState.regular;
        } else if (event.shiftMode == ShiftMode.business && currentState.business != null) {
          selectedShift = currentState.business;
        }

        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('business', selectedShift == currentState.business);

        yield ShiftDetailsReady(currentState.regular, currentState.business, selectedShift);
      }
    }
  }
}

// Events
abstract class ShiftDetailsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ShiftDetailsLoad extends ShiftDetailsEvent {}

class ShiftDetailsSwitch extends ShiftDetailsEvent {
  final ShiftMode shiftMode;

  ShiftDetailsSwitch(this.shiftMode);

  @override
  List<Object> get props => [shiftMode];
}

class ShiftDetailsReload extends ShiftDetailsEvent {
  @override
  List<Object> get props => ['reload'];
}

// States
abstract class ShiftDetailsState extends Equatable {
  @override
  List<Object> get props => [];
}

class ShiftDetailsUninitialized extends ShiftDetailsState {}

class ShiftDetailsLoading extends ShiftDetailsState {}

class ShiftDetailsReady extends ShiftDetailsState {
  final Shift regular;
  final Shift business;
  final Shift current;

  ShiftDetailsReady(this.regular, this.business, this.current);

  bool get useShiftModeSwitch => this.regular != null && this.business != null && this.regular != this.business;
  bool get isRegular => this.current != null && this.regular != null && this.current == this.regular;
  bool get isBusiness =>  this.current != null && this.business != null && this.current == this.business;

  @override
  List<Object> get props => [regular, business, current];
}
