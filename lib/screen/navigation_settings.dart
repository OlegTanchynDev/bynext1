import 'package:bynextcourier/bloc/maps_bloc.dart';
import 'package:bynextcourier/view/app_bar_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationSettingsScreen extends StatelessWidget {

//  @override
//  _NavigationSettingsScreenState createState() => _NavigationSettingsScreenState();
//}
//
//class _NavigationSettingsScreenState extends State<NavigationSettingsScreen> {
//  List<Map> mapList;
//
//  @override
//  void initState() {
//    mapList = [
//      {
//        "name": "Apple Maps",
//        "installed": true,
//        "status": true,
//      },
//      {
//        "name": "Google Maps",
//        "installed": true,
//        "status": false,
//      },
//      {
//        "name": "Waze",
//        "installed": false,
//        "status": false,
//      }
//    ];
//
//    super.initState();
//  }

  @override
  Widget build(BuildContext context) {
    final mapList = ["Apple Maps", "Google Maps", "Waze"];

    return Scaffold(
      appBar: AppBar(
        title: AppBarLogo(),
        centerTitle: true,
        actions: <Widget>[const SizedBox(width: 50)],
      ),
      body: BlocBuilder<MapsBloc, MapsBlocState>(
        builder: (context, mapsState) {
          return Column(
            children: mapList.map((e) =>
              ListTile(
                title: Text(e),
                subtitle: mapsState.installed.contains(e) ? null : Text(
                  "You don't have ${e} installed"),
                trailing: Switch(
                  value: e == mapsState.enabled,
                  onChanged: mapsState.installed.contains(e) && mapsState.enabled != e ? (val) {
                    context.bloc<MapsBloc>().add(SetNavigationType(e));
                  } : null,
                ),
              )).toList(),
          );
        }
      ),
    );
  }
}