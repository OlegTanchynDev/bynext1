import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bynextcourier/model/token.dart';
import 'package:bynextcourier/repository/token_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  TokenRepository repository;

  @override
  get initialState => TokenInitial();

  @override
  Stream<TokenState> mapEventToState(TokenEvent event) async* {
    if (event is ClearToken) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', null);
      await prefs.setString('email', null);
      yield TokenNull();
    }

    if (event is ValidateToken) {
      final prefs = await SharedPreferences.getInstance();
      final token = await prefs.get('token');
      final email = await prefs.get('email');
      final success = await repository.validateCourierLogin(email, "", token);
      if (success) {
        yield TokenValid();
      }
      else {
        yield TokenNull();
      }
    }

    if (event is NewToken) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', event.token.token);
//      await prefs.setString('email', event.token.);

      yield TokenValid();
    }
  }

}

// Events
abstract class TokenEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ValidateToken  extends TokenEvent {}

class NewToken  extends TokenEvent {
  final Token token;

  NewToken(this.token);
}

class ClearToken  extends TokenEvent {}

// States
abstract class TokenState extends Equatable {
  @override
  List<Object> get props => [];
}

class TokenInitial extends TokenState {}

class TokenValid extends TokenState {}

class TokenNull extends TokenState {}
