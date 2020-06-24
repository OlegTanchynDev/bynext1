import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/constants.dart';
import 'package:bynextcourier/generated/l10n.dart';
import 'package:bynextcourier/view/drawer_footer.dart';
import 'package:bynextcourier/view/drawer_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';

import '../router.dart';
import 'welcome_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HiddenDrawer(
        drawerWidth: 250,
        //MediaQuery.of(context).size.width * .4,
        drawerPosition: HiddenDrawerPosition.right,
        drawerHeaderHeight: 130,
        child: WelcomeScreen(),
        drawer: Builder(
          builder: (context) => HiddenDrawerMenu(
            menuActiveColor: Theme.of(context).selectedRowColor,
            header: DrawerHeader(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.brown.shade800,
                    child: Text('AH'),
                    radius: 27,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'John Jonson',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.w500),
                      ),
                      Row(
                        children: <Widget>[
                          Text('Grade: 7.5', style: Theme.of(context).textTheme.headline6),
                          Icon(
                            Icons.star_border,
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            menu: <DrawerMenu>[
              DrawerMenu(
                child: DrawerMenuItem(
                  leading: Image.asset('assets/images/menu-back-to-shift.png'),
                  title: Text(S.of(context).drawerCloseMenu, style: const TextStyle(color: Colors.green)),
                ),
                onPressed: () {},
              ),
              DrawerMenu(
                child: DrawerMenuItem(
                  leading: Image.asset('assets/images/menu-call.png'),
                  title: Text(S.of(context).drawerCallDispatcher, style: const TextStyle(color: Colors.amber)),
                ),
                onPressed: () {},
              ),
              DrawerMenu(
                child: DrawerMenuItem(
                  leading: ColorFiltered(
                    colorFilter: ColorFilter.mode(const Color(0xFF232456), BlendMode.srcIn),
                    child: Image.asset('assets/images/menu-completed-orders.png'),
                  ),
                  title: Text(S.of(context).drawerTasks),
                ),
                onPressed: () => Navigator.of(context).pushNamed(tasksRoute),
              ),
              DrawerMenu(
                child: DrawerMenuItem(
                  leading: ColorFiltered(
                    colorFilter: ColorFilter.mode(const Color(0xFF232456), BlendMode.srcIn),
                    child: Image.asset('assets/images/menu-navigation.png'),
                  ),
                  title: Text(S.of(context).drawerNavigation),
                ),
                onPressed: () => Navigator.of(context).pushNamed(navigationSettingsRoute),
              ),
              DrawerMenu(
                child: DrawerMenuItem(
                  leading: ColorFiltered(
                    colorFilter: ColorFilter.mode(const Color(0xFF232456), BlendMode.srcIn),
                    child: Image.asset('assets/images/menu-shifts.png'),
                  ),
                  title: Text(S.of(context).drawerShifts),
                ),
                onPressed: () => Navigator.of(context).pushNamed(shiftsRoute),
              ),
              DrawerMenu(
                child: DrawerMenuItem(
                  leading: ColorFiltered(
                    colorFilter: ColorFilter.mode(const Color(0xFF232456), BlendMode.srcIn),
                    child: Image.asset('assets/images/menu-my-paycheck.png'),
                  ),
                  title: Text(S.of(context).drawerMySalary),
                ),
                onPressed: () => Navigator.of(context).pushNamed(mySalaryRoute),
              ),
              DrawerMenu(
                child: DrawerMenuItem(
                  leading: ColorFiltered(
                    colorFilter: ColorFilter.mode(const Color(0xFF232456), BlendMode.srcIn),
                    child: Image.asset('assets/images/menu-issues.png'),
                  ),
                  title: Text(S.of(context).drawerIssues),
                ),
                onPressed: () => Navigator.of(context).pushNamed(issuesRoute),
              ),
              DrawerMenu(
                child: DrawerMenuItem(
                  leading: ColorFiltered(
                    colorFilter: ColorFilter.mode(const Color(0xFF232456), BlendMode.srcIn),
                    child: Image.asset('assets/images/menu-language.png'),
                  ),
                  title: Text(S.of(context).drawerGeneralInfo),
                ),
                onPressed: () => Navigator.of(context).pushNamed(webRoute, arguments: {'url': generalInfoUrl, 'title': 'General Info'}),
              ),
              DrawerMenu(
                child: DrawerMenuItem(
                  leading: ColorFiltered(
                    colorFilter: ColorFilter.mode(const Color(0xFF232456), BlendMode.srcIn),
                    child: Image.asset('assets/images/menu-policy.png'),
                  ),
                  title: Text(S.of(context).drawerPolicies),
                ),
                onPressed: () => Navigator.of(context).pushNamed(webRoute, arguments: {'url': policyUrl, 'title': 'Policies'}),
              ),
              DrawerMenu(
                child: DrawerMenuItem(
                  leading: ColorFiltered(
                    colorFilter: ColorFilter.mode(const Color(0xFF232456), BlendMode.srcIn),
                    child: Image.asset('assets/images/menu-question.png'),
                  ),
                  title: Text(S.of(context).drawerSwitchTask),
                ),
                onPressed: () {},
              ),
              DrawerMenu(
                child: DrawerMenuItem(
                  leading: Image.asset('assets/images/menu-logout.png'),
                  title: Text(S.of(context).drawerLogout, style: TextStyle(color: Colors.red)),
                ),
                onPressed: () {
                  BlocProvider.of<TokenBloc>(context).add(ClearToken());
                },
              ),
//          DrawerMenu(
//            child: ListTile(
//              title: Text('Alice'),
//              dense: true,
//            ),
//            onPressed: () {
//              context.read<Alice>().showInspector();
//            },
//          ),
            ],
            footer: DrawerFooter(),
          ),
        ));
  }
}
