import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bynextcourier/model/oauth_token.dart';
import 'package:bynextcourier/repository/token_repository.dart';
import 'package:equatable/equatable.dart';

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  Timer _timer;
  TokenRepository tokenRepository;

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

          OauthToken token = await tokenRepository.login('alex@cleanly.com', 'setup');

//          _timer = new Timer(const Duration(milliseconds: 500), () {
//            add(LoginFormLoggedIn());
//          });

          if (token != null){
            add(LoginFormLoggedIn());
          }
          else {
            add(LoginFormError());
          }
        }
        break;
      case LoginFormLoggedIn:
        yield LoginFormDone();
        break;
    }
  }

  submit() {
    add(LoginFormSubmit());
  }
}

class LoginFormEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginFormSubmit extends LoginFormEvent {}

class LoginFormLoggedIn extends LoginFormEvent {}

class LoginFormError extends LoginFormEvent {}

// States
abstract class LoginFormState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginFormReady extends LoginFormState {}

class LoginFormProcessing extends LoginFormState {}

class LoginFormDone extends LoginFormState {}
