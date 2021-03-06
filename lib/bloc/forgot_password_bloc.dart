import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bynextcourier/model/rest_error.dart';
import 'package:bynextcourier/repository/token_repository.dart';
import 'package:equatable/equatable.dart';

import 'http_client_bloc.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
//  Timer _timer;
  TokenRepository tokenRepository;
  // ignore: close_sinks
  HttpClientBloc httpClientBloc;

  ForgotPasswordBloc() : super(ForgotFormReady());

//  @override
//  Future<void> close() {
//    _timer?.cancel();
//    return super.close();
//  }

  @override
  Stream<ForgotPasswordState> mapEventToState(ForgotPasswordEvent event) async* {
    switch (event.runtimeType) {
      case ForgotFormSubmit:
        if (state is ForgotFormReady) {
          yield ForgotFormProcessing();

          try {
            final response =
                await tokenRepository.resetPassword(httpClientBloc.state.client, (event as ForgotFormSubmit).username);
            yield ForgotFormDone();
          } catch (error) {
            if (error is RestError) {
              yield ForgotFormReady(
                error: error.errors,
              );
            }
          }
        }
        break;
    }
  }

  submit(String username) {
    add(ForgotFormSubmit(username));
  }
}

class ForgotPasswordEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ForgotFormSubmit extends ForgotPasswordEvent {
  final String username;

  ForgotFormSubmit(this.username);
}

// States
abstract class ForgotPasswordState extends Equatable {
  @override
  List<Object> get props => [];
}

class ForgotFormReady extends ForgotPasswordState {
  final error;

  ForgotFormReady({this.error});
}

class ForgotFormProcessing extends ForgotPasswordState {}

class ForgotFormDone extends ForgotPasswordState {}
