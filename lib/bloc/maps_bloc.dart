import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapsBloc extends Bloc<MapsBlocEvent, MapsBlocState> {

  MapsBloc() : super(MapsBlocState(
    installed: [],
    enabled: "",
  ));

  @override
  Stream<MapsBlocState> mapEventToState(MapsBlocEvent event) async* {
    if (event is CheckInstalled) {
      List<AvailableMap> available = await MapLauncher.installedMaps;
      List<String> installed = available.map((e) => e.mapName).toList();
      var prefs = await SharedPreferences.getInstance();
      var map = prefs.getString('map');
      var availableMap = available.firstWhere((element) => element.mapName == map, orElse: () => null,);

      yield MapsBlocState(
          installed: installed,
          enabled: availableMap != null ? availableMap.mapName : installed.first
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

class CheckInstalled extends MapsBlocEvent {}

class SetNavigationType extends MapsBlocEvent {
  final String navType;

  SetNavigationType(this.navType);
}

// States
class MapsBlocState extends Equatable {
  final List<String> installed;
  final String enabled;

  MapsBlocState({this.installed, this.enabled});

  @override
  List<Object> get props => [installed, enabled];
}
