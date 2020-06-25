import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:url_launcher/url_launcher.dart';

class MapsBloc extends Bloc<MapsBlocEvent, MapsBlocState> {

  @override
  get initialState => MapsBlocState(
    installed: [],
    enabled: ""
  );

  @override
  Stream<MapsBlocState> mapEventToState(MapsBlocEvent event) async* {
    if (event is CheckInstalled) {
      List<String> installed = [];
      if(await canLaunch("comgooglemaps://")){
        installed.add("Google Maps");
      }
      if(await canLaunch("https://maps.apple.com/")){
        installed.add("Apple Maps");
      }
      if(await canLaunch("waze://")){
        installed.add("Waze");
      }

      yield MapsBlocState(
        installed: installed,
        enabled: installed.first
      );
    }

    if (event is SetNavigationType) {
      if (state.installed.contains(event.navType)) {
        yield MapsBlocState(
          installed: state.installed,
          enabled: event.navType,
        );
      }
      else {
        yield MapsBlocState(
          installed: state.installed,
          enabled: state.enabled,
        );
      }
    }
  }

}

// Events
abstract class MapsBlocEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckInstalled  extends MapsBlocEvent {}

class SetNavigationType  extends MapsBlocEvent {
  final String navType;

  SetNavigationType(this.navType);
}

// States
class MapsBlocState extends Equatable {
  final List<String> installed;
  final String enabled;

  MapsBlocState({this.installed, this.enabled});

  @override
  List<Object> get props => [];
}
