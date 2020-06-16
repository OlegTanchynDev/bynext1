import 'package:flutter/material.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HiddenDrawer(
      drawerWidth: 250, //MediaQuery.of(context).size.width * .4,
      drawerPosition: HiddenDrawerPosition.right,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            HiddenDrawerIcon(),
          ],
        ),
        body: Center(child: Text('Hey, John!')),
      ),
      drawer: HiddenDrawerMenu(
        menu: <DrawerMenu>[
          DrawerMenu(
            child: ListTile(
              leading: Icon(Icons.phone),
              title: Text('Call Dispatcher'),
            ), onPressed: () {  },
          ),
          DrawerMenu(
            child: ListTile(
              leading: Icon(Icons.local_offer),
              title: Text('Call Dispatcher'),
            ), onPressed: () {  },
          ),
        ],
      ),
    );
  }
}
