import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/model/profile.dart';
import 'package:bynextcourier/repository/profile_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'http_client_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileRepository repository;
  TokenBloc _tokenBloc;
  // ignore: close_sinks
  HttpClientBloc httpClientBloc;

  StreamSubscription<TokenState> _tokenSubscription;

  ProfileBloc() : super(ProfileState(null));

  set tokenBloc(TokenBloc value) {
    if (_tokenBloc != value) {
      _tokenBloc = value;
      _tokenSubscription = _tokenBloc.listen((tokenState) {
        if (tokenState.token != null) {
          add(GetProfile());
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
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ClearProfile) {
      yield ProfileState(null);
    }

    if (event is GetProfile) {
      try {
        final profile = await repository.fetchProfile(httpClientBloc.state.client, _tokenBloc.state.token);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(Profile.keyCaptureLocationIntervalSec, profile.captureLocationIntervalSec);
        await prefs.setInt(Profile.keySendLocationIntervalSec, profile.sendLocationIntervalSec);
        await prefs.setInt(Profile.keyDistanceToleranceMeter, profile.distanceToleranceMeter);
        await prefs.setInt(Profile.keyMinimumGeoLocationDistance, profile.minimumGeoLocationDistance);
        yield ProfileState(profile);
      } catch (e) {
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

class GetProfile extends ProfileEvent {}

class ClearProfile extends ProfileEvent {}

// States
class ProfileState extends Equatable {
  ProfileState(this.profile);

  @override
  List<Object> get props => [profile];

  final Profile profile;
}
