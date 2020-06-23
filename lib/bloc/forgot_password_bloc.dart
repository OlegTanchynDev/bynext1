import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/model/rest_error.dart';
import 'package:bynextcourier/model/token.dart';
import 'package:bynextcourier/repository/token_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  Timer _timer;
  TokenRepository tokenRepository;

  TokenBloc tokenBloc;

  @override
  ForgotPasswordState get initialState => LoginFormReady();

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  @override
  Stream<ForgotPasswordState> mapEventToState(ForgotPasswordEvent event) async* {
    switch (event.runtimeType) {
      case LoginFormSubmit:
        if (state is LoginFormReady) {
          yield LoginFormProcessing();

          try {
            Token token = await tokenRepository.login(
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

class ForgotPasswordEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginFormSubmit extends ForgotPasswordEvent {
  final String username;
  final String password;

  LoginFormSubmit(this.username, this.password);
}

class LoginFormLoggedIn extends ForgotPasswordEvent {}

// States
abstract class ForgotPasswordState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginFormReady extends ForgotPasswordState {
  final error;

  LoginFormReady({this.error});
}

class LoginFormProcessing extends ForgotPasswordState {}

class LoginFormDone extends ForgotPasswordState {}
