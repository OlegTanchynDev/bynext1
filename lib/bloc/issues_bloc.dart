import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/model/issue.dart';
import 'package:bynextcourier/repository/issues_repository.dart';
import 'package:equatable/equatable.dart';

import 'http_client_bloc.dart';

class IssuesBloc extends Bloc<IssuesEvent, IssuesState> {
  IssueRepository repository;
  TokenBloc _tokenBloc;
  // ignore: close_sinks
  HttpClientBloc httpClientBloc;

  StreamSubscription<TokenState> _tokenSubscription;

  IssuesBloc() : super(IssuesState([]));

  set tokenBloc(TokenBloc value) {
    if (_tokenBloc != value){
      _tokenBloc = value;
      _tokenSubscription = _tokenBloc.listen((tokenState) {
        if(tokenState.token != null){
          add(GetIssues());
//          _tokenSubscription.cancel();
        }
      });
    }
  }


  @override
  Future<void> close() {
    _tokenSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<IssuesState> mapEventToState(IssuesEvent event) async* {
    if (event is GetIssues) {
      try {
        final profile = await repository.fetchIssues(httpClientBloc.state.client, _tokenBloc.state.token);
        yield IssuesState(profile);
      }
      catch (e){
        yield IssuesState(null);
      }
    }
  }
}

// Events
abstract class IssuesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetIssues  extends IssuesEvent {}

// States
class IssuesState extends Equatable {
  IssuesState(this.issues);

  @override
  List<Object> get props => [issues];

  final List<Issue> issues;
}
