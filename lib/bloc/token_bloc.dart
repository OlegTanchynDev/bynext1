import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/http_client_bloc.dart';
import 'package:bynextcourier/model/token.dart';
import 'package:bynextcourier/repository/token_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  TokenRepository repository;
  // ignore: close_sinks
  HttpClientBloc httpClientBloc;

  TokenBloc() : super(TokenInitial());

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
      final token = prefs.getString('token');
      final email = prefs.getString('email');
      if (email != null && token != null) {
        final success = await repository.validateCourierLogin(httpClientBloc.state.client,
          email, "1.2.3", token);

        if (success) {
          yield TokenValid(token, email);
        }
        else {
          yield TokenNull();
        }
      }
      else {
        // application start, show splash screen for 2 seconds
        if (state is TokenInitial) {
          Future.delayed(const Duration(seconds: 2), () {
            add(ClearToken());
          });
        } else {
          yield TokenNull();
        }
      }
    }

    if (event is NewToken) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', event.token.token);
      await prefs.setString('email', event.email);

      yield TokenValid(event.token.token, event.email);
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
  final String email;
  final bool demo;

  NewToken(this.token, this.email, {this.demo = false});

  @override
  List<Object> get props => [token, email, demo];
}

class ClearToken  extends TokenEvent {}

// States
abstract class TokenState extends Equatable {
  final String token;
  final String email;

  TokenState(this.token, this.email);

  @override
  List<Object> get props => [token, email];
}

class TokenInitial extends TokenState {
  TokenInitial() : super(null, null);
}

class TokenValid extends TokenState {
  TokenValid(String token, String email) : super(token, email);
}

class TokenNull extends TokenState {
  TokenNull() : super(null, null);
}
