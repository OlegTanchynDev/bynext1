import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  Timer _timer;

  SplashBloc() : super(SplashVisible());

  start() {
    _timer = new Timer(const Duration(seconds: 3), () {
      add(SplashTimeout());
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    if (event is SplashTimeout) {
      yield SplashDone();
    }
  }

}

// Events
abstract class SplashEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SplashTimeout  extends SplashEvent {}

// States
abstract class SplashState extends Equatable {
  @override
  List<Object> get props => [];
}

class SplashVisible extends SplashState {}

class SplashDone extends SplashState {}
