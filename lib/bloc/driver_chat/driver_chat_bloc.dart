import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/http_client_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/repository/driver_chat_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'driver_chat_event.dart';

part 'driver_chat_state.dart';

class DriverChatBloc extends Bloc<DriverChatEvent, DriverChatState> {

  DriverChatRepository repository;
  // ignore: close_sinks
  TokenBloc tokenBloc;
  // ignore: close_sinks
  HttpClientBloc httpClientBloc;

  DriverChatBloc() : super(InitialDriverChatState());

  @override
  Stream<DriverChatState> mapEventToState(DriverChatEvent event) async* {
    if (event is GetFirebaseAuthEvent) {
      var response = await repository.performGetFirebaseAuthSuccessBlock(
          httpClientBloc.state.client, tokenBloc.state.token, event.taskId);
      printLabel('response: $response', 'DriverChatBloc');
    }
  }
}
