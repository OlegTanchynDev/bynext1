import 'package:bynextcourier/view/app_bar_logo.dart';
import 'package:flutter/material.dart';

class NavigationSettingsScreen extends StatefulWidget {

  @override
  _NavigationSettingsScreenState createState() => _NavigationSettingsScreenState();
}

class _NavigationSettingsScreenState extends State<NavigationSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final mapList = ["Apple Maps", "Google Maps", "Waze"];

    return Scaffold(
      appBar: AppBar(
        title: AppBarLogo(),
        centerTitle: true,
        actions: <Widget>[const SizedBox(width: 50)],
      ),
      body: Column(
        children: mapList.map((e) => ListTile(
          title: Text(e),
          subtitle: Text("You don't have $e installed"),
          trailing: Switch(
            value: false,
//            onChanged: (val) => ,
          ),
        )).toList(),
      ),
    );
  }
}