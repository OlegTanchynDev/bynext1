import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/model/shift.dart';
import 'package:bynextcourier/repository/shift_details_repository.dart';
import 'package:equatable/equatable.dart';

class ShiftDetailsBloc extends Bloc<ShiftDetailsEvent, ShiftDetailsState> {
  ShiftDetailsRepository repository;
  TokenBloc _tokenBloc;

  StreamSubscription<TokenState> _tokenBlocSubscription;

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
  Future<Function> close() {
    _tokenBlocSubscription?.cancel();
    return super.close();
  }

  @override
  ShiftDetailsState get initialState => ShiftDetailsUninitialized();

  @override
  Stream<ShiftDetailsState> mapEventToState(ShiftDetailsEvent event) async* {
    if (event is ShiftDetailsLoad) {
      yield* _mapLoadToState();
    }
  }

  Stream<ShiftDetailsState> _mapLoadToState() async* {
    yield ShiftDetailsLoading();

    final shift = await repository.fetchShiftDetails(_tokenBloc.state?.token);

    yield ShiftDetailsReady(shift);
  }

}

// Events
abstract class ShiftDetailsEvent extends Equatable {
  @override

  List<Object> get props => [];
}

class ShiftDetailsLoad extends ShiftDetailsEvent {}

// States
abstract class ShiftDetailsState extends Equatable {
  @override
  List<Object> get props => [];
}

class ShiftDetailsUninitialized extends ShiftDetailsState {}

class ShiftDetailsLoading extends ShiftDetailsState {}

class ShiftDetailsReady extends ShiftDetailsState {
  final Shift shift;

  ShiftDetailsReady(this.shift);

  @override
  List<Object> get props => [shift];
}