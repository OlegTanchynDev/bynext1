import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bynextcourier/model/rest_error.dart';
import 'package:bynextcourier/model/token.dart';
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

          try {
            Token token = await tokenRepository.login(
              (event as LoginFormSubmit).username,
              (event as LoginFormSubmit).password);

//            add(LoginFormLoggedIn());
            yield LoginFormDone();
          }
          catch (error) {
            if (error is RestError){
              yield LoginFormReady(
                error: error.errors,
              );
            }
          }

//          if (token != null){
//            add(LoginFormLoggedIn());
//          }
//          else {
//            add(LoginFormError());
//          }
        }
        break;
      case LoginFormLoggedIn:
        yield LoginFormDone();
        break;

//      case LoginFormError:
//        yield LoginFormReady(
//          error:
//        );
//        break;
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

//class LoginFormError extends LoginFormEvent {}

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
