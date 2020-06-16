import 'package:bynextcourier/generated/l10n.dart';
import 'package:bynextcourier/view/drawer_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HiddenDrawer(
      drawerWidth: 250,
      //MediaQuery.of(context).size.width * .4,
      drawerPosition: HiddenDrawerPosition.right,
      drawerHeaderHeight: 130,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            HiddenDrawerIcon(),
          ],
        ),
        body: Center(child: Text('Hey, John!')),
      ),
      drawer: HiddenDrawerMenu(
        header: DrawerHeader(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.brown.shade800,
                child: Text('AH'),
                radius: 30,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('John Jonson'),
                  Row(
                    children: <Widget>[
                      Text('Grade: 7.5'),
                      Icon(Icons.star_border),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        menu: <DrawerMenu>[
          DrawerMenu(
            child: ListTile(
              leading: Icon(Icons.arrow_left),
              title: Text(S.of(context).drawerCloseMenu),
              dense: true,
            ),
            onPressed: () => HiddenDrawer.of(context).handleDrawer(),
          ),
          DrawerMenu(
            child: ListTile(
              leading: Icon(Icons.phone),
              title: Text(S.of(context).drawerCallDispatcher),
              dense: true,
            ),
            onPressed: () {},
          ),
          DrawerMenu(
            child: ListTile(
              leading: Icon(Icons.local_offer),
              title: Text(S.of(context).drawerTasks),
              dense: true,
            ),
            onPressed: () {},
          ),
          DrawerMenu(
            child: ListTile(
              leading: Icon(Icons.local_offer),
              title: Text(S.of(context).drawerNavigation),
              dense: true,
            ),
            onPressed: () {},
          ),
          DrawerMenu(
            child: ListTile(
              leading: Icon(Icons.local_offer),
              title: Text(S.of(context).drawerShifts),
              dense: true,
            ),
            onPressed: () {},
          ),
          DrawerMenu(
            child: ListTile(
              leading: Icon(Icons.local_offer),
              title: Text(S.of(context).drawerMySalary),
              dense: true,
            ),
            onPressed: () {},
          ),
          DrawerMenu(
            child: ListTile(
              leading: Icon(Icons.local_offer),
              title: Text(S.of(context).drawerIssues),
              dense: true,
            ),
            onPressed: () {},
          ),
          DrawerMenu(
            child: ListTile(
              leading: Icon(Icons.local_offer),
              title: Text(S.of(context).drawerGeneralInfo),
              dense: true,
            ),
            onPressed: () {},
          ),
          DrawerMenu(
            child: ListTile(
              leading: Icon(Icons.local_offer),
              title: Text(S.of(context).drawerPolicies),
              dense: true,
            ),
            onPressed: () {},
          ),
          DrawerMenu(
            child: ListTile(
              leading: Icon(Icons.local_offer),
              title: Text(S.of(context).drawerSwitchTask),
              dense: true,
            ),
            onPressed: () {},
          ),
          DrawerMenu(
            child: ListTile(
              leading: Icon(Icons.local_offer),
              title: Text(S.of(context).drawerLogout),
              dense: true,
            ),
            onPressed: () {},
          ),
        ],
        footer: DrawerFooter(),
      ),
    );
  }
}
