import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/http_client_bloc.dart';
import 'package:bynextcourier/bloc/profile_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/repository/issues_repository.dart';
import 'package:meta/meta.dart';

part 'sign_contract_event.dart';

part 'sign_contract_state.dart';

class SignContractBloc extends Bloc<SignContractEvent, SignContractState> {
  IssueRepository repository;
  TokenBloc tokenBloc;
  HttpClientBloc httpClientBloc;

  @override
  SignContractState get initialState => InitialSignContractState();

  @override
  Stream<SignContractState> mapEventToState(SignContractEvent event) async* {
    // TODO: Add your event logic
  }
}
