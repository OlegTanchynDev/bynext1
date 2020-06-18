import 'package:alice/alice.dart';
import 'package:bynextcourier/constants.dart';
import 'package:bynextcourier/generated/l10n.dart';
import 'package:bynextcourier/view/drawer_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';

import '../router.dart';

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
              leading: Image.asset('assets/images/menu-back-to-shift.png'),
              title: Text(S.of(context).drawerCloseMenu),
              dense: true,
            ),
            onPressed: () => HiddenDrawer.of(context).handleDrawer(),
          ),
          DrawerMenu(
            child: ListTile(
              leading: Image.asset('assets/images/menu-call.png'),
              title: Text(S.of(context).drawerCallDispatcher),
              dense: true,
            ),
            onPressed: () {},
          ),
          DrawerMenu(
            child: ListTile(
              leading: ColorFiltered(
                colorFilter: ColorFilter.mode(Color(0xFF232456), BlendMode.srcIn),
                child: Image.asset('assets/images/menu-completed-orders.png'),
              ),
              title: Text(S.of(context).drawerTasks),
              dense: true,
            ),
            onPressed: () {},
          ),
          DrawerMenu(
            child: ListTile(
              leading: ColorFiltered(
                colorFilter: ColorFilter.mode(Color(0xFF232456), BlendMode.srcIn),
                child: Image.asset('assets/images/menu-navigation.png'),
              ),
              title: Text(S.of(context).drawerNavigation),
              dense: true,
            ),
            onPressed: () {},
          ),
          DrawerMenu(
            child: ListTile(
              leading: ColorFiltered(
                colorFilter: ColorFilter.mode(Color(0xFF232456), BlendMode.srcIn),
                child: Image.asset('assets/images/menu-shifts.png'),
              ),
              title: Text(S.of(context).drawerShifts),
              dense: true,
            ),
            onPressed: () {},
          ),
          DrawerMenu(
            child: ListTile(
              leading: ColorFiltered(
                colorFilter: ColorFilter.mode(Color(0xFF232456), BlendMode.srcIn),
                child: Image.asset('assets/images/menu-my-paycheck.png'),
              ),
              title: Text(S.of(context).drawerMySalary),
              dense: true,
            ),
            onPressed: () {},
          ),
          DrawerMenu(
            child: ListTile(
              leading: ColorFiltered(
                colorFilter: ColorFilter.mode(Color(0xFF232456), BlendMode.srcIn),
                child: Image.asset('assets/images/menu-issues.png'),
              ),
              title: Text(S.of(context).drawerIssues),
              dense: true,
            ),
            onPressed: () {},
          ),
          DrawerMenu(
            child: ListTile(
              leading: Icon(Icons.language),
              title: Text(S.of(context).drawerGeneralInfo),
              dense: true,
            ),
            onPressed: () => Navigator.of(context).pushNamed(webRoute, arguments: {'url': generalInfoUrl}),
          ),
          DrawerMenu(
            child: ListTile(
              leading: ColorFiltered(
                colorFilter: ColorFilter.mode(Color(0xFF232456), BlendMode.srcIn),
                child: Image.asset('assets/images/menu-policy.png'),
              ),
              title: Text(S.of(context).drawerPolicies),
              dense: true,
            ),
            onPressed: () => Navigator.of(context).pushNamed(webRoute, arguments: {'url': policyUrl}),
          ),
          DrawerMenu(
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Color(0xFF232456))),
                child: Text('?'),
              ),
              title: Text(S.of(context).drawerSwitchTask),
              dense: true,
            ),
            onPressed: () {},
          ),
          DrawerMenu(
            child: ListTile(
              leading: Image.asset('assets/images/menu-logout.png'),
              title: Text(S.of(context).drawerLogout),
              dense: true,
            ),
            onPressed: () {},
          ),
          DrawerMenu(
            child: ListTile(
              title: Text('Alice'),
              dense: true,
            ),
            onPressed: () {
              context.read<Alice>().showInspector();
            },
          ),
        ],
        footer: DrawerFooter(),
      ),
    );
  }
}
