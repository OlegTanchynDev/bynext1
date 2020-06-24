import 'package:bynextcourier/view/app_bar_logo.dart';
import 'package:flutter/material.dart';

class NavigationSettingsScreen extends StatefulWidget {

  @override
  _NavigationSettingsScreenState createState() => _NavigationSettingsScreenState();
}

class _NavigationSettingsScreenState extends State<NavigationSettingsScreen> {
  List<Map> mapList;

  @override
  void initState() {
    mapList = [
      {
        "name": "Apple Maps",
        "installed": true,
        "status": true,
      },
      {
        "name": "Google Maps",
        "installed": true,
        "status": false,
      },
      {
        "name": "Waze",
        "installed": false,
        "status": false,
      }
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    final mapList = ["Apple Maps", "Google Maps", "Waze"];
//    final statusList = [, "Google Maps", "Waze"];

    return Scaffold(
      appBar: AppBar(
        title: AppBarLogo(),
        centerTitle: true,
        actions: <Widget>[const SizedBox(width: 50)],
      ),
      body: Column(
        children: mapList.map((e) =>
          ListTile(
            title: Text(e['name']),
            subtitle: e['installed'] ? null : Text(
              "You don't have ${e['name']} installed"),
            trailing: Switch(
              value: e['status'],
              onChanged: e['installed'] ? (val) {
                e['status'] = !(e['status']);
                setState(() {
                  mapList = mapList;
                });
              } : null,
            ),
          )).toList(),
      ),
    );
  }
}