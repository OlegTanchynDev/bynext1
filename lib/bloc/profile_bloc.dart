import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/model/profile.dart';
import 'package:bynextcourier/repository/profile_repository.dart';
import 'package:equatable/equatable.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileRepository repository;
  TokenBloc _tokenBloc;

  StreamSubscription<TokenState> _tokenSubscription;


  set tokenBloc(TokenBloc value) {
    if (_tokenBloc != value){
      _tokenBloc = value;
      _tokenSubscription = _tokenBloc.listen((tokenState) {
        if(tokenState.token != null){
          add(GetProfile());
//          _tokenSubscription.cancel();
        }
      });
    }
  }


  @override
  Future<Function> close() {
    _tokenSubscription?.cancel();
    return super.close();
  }

  @override
  get initialState => ProfileState(null);

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ClearProfile) {
      yield ProfileState(null);
    }

    if (event is GetProfile) {
      try {
        final profile = await repository.fetchProfile(_tokenBloc.state.token);
        yield ProfileState(profile);
      }
      catch (e){
        yield ProfileState(null);
      }
    }
  }
}

// Events
abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetProfile  extends ProfileEvent {}

class ClearProfile  extends ProfileEvent {}

// States
class ProfileState extends Equatable {
  ProfileState(this.profile);

  @override
  List<Object> get props => [profile];

  final Profile profile;
}
