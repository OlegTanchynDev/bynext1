import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/model/rest_error.dart';
import 'package:bynextcourier/model/token.dart';
import 'package:bynextcourier/repository/token_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
//  Timer _timer;
  TokenRepository tokenRepository;
//
//  TokenBloc tokenBloc;

  @override
  ForgotPasswordState get initialState => ForgotFormReady();

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
          final response = await tokenRepository.resetPassword((event as ForgotFormSubmit).username);


//          try {
//            Token token = await tokenRepository.login(
//              (event as LoginFormSubmit).username,
//              (event as LoginFormSubmit).password);
//
//            tokenBloc.add(NewToken(token, (event as LoginFormSubmit).username));
//
//            yield ForgotFormDone();
//          }
//          catch (error) {
//            if (error is RestError){
//              yield ForgotFormReady(
//                error: error.errors,
//              );
//            }
//          }

          yield ForgotFormDone();
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
