import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/model/rest_error.dart';
import 'package:bynextcourier/model/token.dart';
import 'package:bynextcourier/repository/token_repository.dart';
import 'package:equatable/equatable.dart';

import 'http_client_bloc.dart';

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  Timer _timer;
  TokenRepository tokenRepository;
  HttpClientBloc httpClientBloc;

  TokenBloc tokenBloc;

  @override
  LoginFormState get initialState => LoginFormReady();

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  @override
  Stream<LoginFormState> mapEventToState(LoginFormEvent event) async* {
    switch (event.runtimeType) {
      case LoginFormSubmit:
        if (state is LoginFormReady) {
          yield LoginFormProcessing();

          try {
            Token token = await tokenRepository.login(
              httpClientBloc.state.client,
              (event as LoginFormSubmit).username,
              (event as LoginFormSubmit).password);

            tokenBloc.add(NewToken(token, (event as LoginFormSubmit).username));

            yield LoginFormDone();
          }
          catch (error) {
            if (error is RestError){
              yield LoginFormReady(
                error: error.errors,
              );
            }
          }
        }
        break;
      case LoginFormLoggedIn:
        yield LoginFormDone();
        break;
    }
  }

  submit(String username, String password) {
    add(LoginFormSubmit(username, password));
  }
}

class LoginFormEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginFormSubmit extends LoginFormEvent {
  final String username;
  final String password;

  LoginFormSubmit(this.username, this.password);
}

class LoginFormLoggedIn extends LoginFormEvent {}

// States
abstract class LoginFormState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginFormReady extends LoginFormState {
  final error;

  LoginFormReady({this.error});
}

class LoginFormProcessing extends LoginFormState {}

class LoginFormDone extends LoginFormState {}
