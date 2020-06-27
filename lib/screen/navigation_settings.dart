import 'package:bynextcourier/bloc/maps_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationSettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final mapList = ["Apple Maps", "Google Maps", "Waze"];

    return Scaffold(
      appBar: AppBar(
        title: Text("Navigation Selection"),
        centerTitle: true,
        actions: <Widget>[const SizedBox(width: 50)],
      ),
      body: BlocBuilder<MapsBloc, MapsBlocState>(
        builder: (context, mapsState) {
          return Column(
            children: mapList.map((e) {
              return ListTile(
                title: Text(e),
                subtitle: mapsState.installed.contains(e) ? null : Text(
                  "You don't have $e installed"),
                trailing: Switch(
                  value: e == mapsState.enabled,
                  onChanged: mapsState.installed.contains(e) ? (val){
                    if(mapsState.enabled != e){
                      context.bloc<MapsBloc>().add(SetNavigationType(e));
                    }
                  }
                   : null,
                ),
              );
            }).toList(),
          );
        }
      ),
    );
  }
}