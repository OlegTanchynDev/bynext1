import 'package:bynextcourier/bloc/http_client_bloc.dart';
import 'package:bynextcourier/bloc/profile_bloc.dart';
import 'package:bynextcourier/bloc/shift_details_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/client/app_http_client.dart';
import 'package:bynextcourier/constants.dart';
import 'package:bynextcourier/generated/l10n.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/model/shift.dart';
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
    return BlocBuilder<ShiftDetailsBloc, ShiftDetailsState>(builder: (context, shiftDetailsState) {
      final shift = shiftDetailsState is ShiftDetailsReady ? shiftDetailsState.current : null;
      final dispatcherPhone = shift?.dispatcherPhone;
      final showShiftModeSelector =
          shiftDetailsState is ShiftDetailsReady ? shiftDetailsState.useShiftModeSwitch : false;
      final currentShiftModeBusiness =
          shiftDetailsState is ShiftDetailsReady ? shiftDetailsState.current == shiftDetailsState.business : false;
      return BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          final hideInfo = profileState.profile?.rateSystem == RateSystem.DELIVERY_COURIER_PAYMENT_EMPLOYEE_HIDE_INFO ?? false;
          return HiddenDrawer(
              drawerWidth: 250,
              //MediaQuery.of(context).size.width * .4,
              drawerPosition: HiddenDrawerPosition.right,
              drawerHeaderHeight: 70.0 + (showShiftModeSelector ? 42 : 0),
              child: WelcomeScreen(),
              drawer: BlocBuilder<HttpClientBloc, HttpClientState>(
                  builder: (context, httpClientState) => Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: HiddenDrawerMenu(
                          menuActiveColor: Theme.of(context).selectedRowColor,
                          header: DrawerHeader(
                            padding: EdgeInsets.only(left: 20),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage: profileState.profile?.profilePhotoUrl != null
                                          ? NetworkImage(mediaUrl + (profileState.profile?.profilePhotoUrl))
                                          : null,
                                      backgroundColor: Colors.brown.shade800,
                                      child: profileState.profile?.profilePhotoUrl == null ? Text('AH') : null,
                                      radius: 27,
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '${profileState.profile?.firstName ?? ""} ${profileState.profile?.lastName ?? ""}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(fontWeight: FontWeight.w500),
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
                                showShiftModeSelector
                                    ? Row(
                                        children: <Widget>[
                                          Text('Shift'),
                                          Switch(
                                              value: currentShiftModeBusiness,
                                              onChanged: (val) => context.bloc<ShiftDetailsBloc>().add(
                                                  ShiftDetailsSwitch(val ? ShiftMode.business : ShiftMode.regular))),
                                          Text('Business'),
                                        ],
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                          menu: <DrawerMenu>[
                                DrawerMenu(
                                  child: DrawerMenuItem(
                                    leading: ColorFiltered(
                                        colorFilter: const ColorFilter.mode(const Color(0xFF232456), BlendMode.srcIn),
                                        child: Image.asset('assets/images/menu-call.png')),
                                    title: Text(S.of(context).drawerCallDispatcher),
                                  ),
                                  onPressed: dispatcherPhone != null
                                      ? () {
                                          callPhone(context, dispatcherPhone, shift?.dispatcherName);
                                        }
                                      : null,
                                ),
                                DrawerMenu(
                                  child: DrawerMenuItem(
                                    leading: ColorFiltered(
                                      colorFilter: const ColorFilter.mode(const Color(0xFF232456), BlendMode.srcIn),
                                      child: Image.asset('assets/images/menu-completed-orders.png'),
                                    ),
                                    title: Text(S.of(context).drawerTasks),
                                  ),
                                  onPressed: () => Navigator.of(context).pushNamed(tasksRoute),
                                ),
                                DrawerMenu(
                                  child: DrawerMenuItem(
                                    leading: ColorFiltered(
                                      colorFilter: const ColorFilter.mode(const Color(0xFF232456), BlendMode.srcIn),
                                      child: Image.asset('assets/images/menu-navigation.png'),
                                    ),
                                    title: Text(S.of(context).drawerNavigation),
                                  ),
                                  onPressed: () => Navigator.of(context).pushNamed(navigationSettingsRoute),
                                )
                              ] +
                              (hideInfo
                                  ? []
                                  : [
                                      DrawerMenu(
                                        child: DrawerMenuItem(
                                          leading: ColorFiltered(
                                            colorFilter:
                                                const ColorFilter.mode(const Color(0xFF232456), BlendMode.srcIn),
                                            child: Image.asset('assets/images/menu-shifts.png'),
                                          ),
                                          title: Text(shiftDetailsState is ShiftDetailsReady &&
                                                  [
                                                    RateSystem.DELIVERY_COURIER_PAYMENT_EMPLOYEE,
                                                    RateSystem.DELIVERY_COURIER_PAYMENT_EMPLOYEE_FIXED_RUN_COST
                                                  ].contains(shiftDetailsState.current.contractRateSystem)
                                              ? S.of(context).drawerShifts
                                              : S.of(context).drawerJobs),
                                        ),
                                        onPressed: () => Navigator.of(context).pushNamed(shiftsRoute),
                                      ),
                                      DrawerMenu(
                                        child: DrawerMenuItem(
                                          leading: ColorFiltered(
                                            colorFilter:
                                                const ColorFilter.mode(const Color(0xFF232456), BlendMode.srcIn),
                                            child: Image.asset('assets/images/menu-my-paycheck.png'),
                                          ),
                                          title: Text(shiftDetailsState is ShiftDetailsReady &&
                                                  [
                                                    RateSystem.DELIVERY_COURIER_PAYMENT_EMPLOYEE,
                                                    RateSystem.DELIVERY_COURIER_PAYMENT_EMPLOYEE_FIXED_RUN_COST
                                                  ].contains(shiftDetailsState.current.contractRateSystem)
                                              ? S.of(context).drawerMySalary
                                              : S.of(context).drawerMyInvoice),
                                        ),
                                        onPressed: () => Navigator.of(context).pushNamed(mySalaryRoute),
                                      ),
                                    ]) +
                              [
                                DrawerMenu(
                                  child: DrawerMenuItem(
                                    leading: ColorFiltered(
                                      colorFilter: const ColorFilter.mode(const Color(0xFF232456), BlendMode.srcIn),
                                      child: Image.asset('assets/images/menu-issues.png'),
                                    ),
                                    title: Text(S.of(context).drawerIssues),
                                  ),
                                  onPressed: () => Navigator.of(context).pushNamed(issuesRoute),
                                )
                              ] +
                              (hideInfo
                                  ? []
                                  : [
                                      DrawerMenu(
                                        child: DrawerMenuItem(
                                          leading: ColorFiltered(
                                            colorFilter:
                                                const ColorFilter.mode(const Color(0xFF232456), BlendMode.srcIn),
                                            child: Image.asset('assets/images/menu-language.png'),
                                          ),
                                          title: Text(S.of(context).drawerGeneralInfo),
                                        ),
                                        onPressed: () => Navigator.of(context).pushNamed(webRoute,
                                            arguments: {'url': generalInfoUrl, 'title': 'General Info'}),
                                      ),
                                      DrawerMenu(
                                        child: DrawerMenuItem(
                                          leading: ColorFiltered(
                                            colorFilter:
                                                const ColorFilter.mode(const Color(0xFF232456), BlendMode.srcIn),
                                            child: Image.asset('assets/images/menu-policy.png'),
                                          ),
                                          title: Text(S.of(context).drawerPolicies),
                                        ),
                                        onPressed: () => Navigator.of(context)
                                            .pushNamed(webRoute, arguments: {'url': policyUrl, 'title': 'Policies'}),
                                      ),
                                    ]) +
                              (httpClientState.demo
                                  ? [
                                      DrawerMenu(
                                        child: DrawerMenuItem(
                                          leading: ColorFiltered(
                                            colorFilter:
                                                const ColorFilter.mode(const Color(0xFF232456), BlendMode.srcIn),
                                            child: Image.asset('assets/images/menu-question.png'),
                                          ),
                                          title: Text(S.of(context).drawerSwitchTask),
                                        ),
                                        onPressed: () async {
                                          DemoTasks nextTask = await showCustomDialog2(
                                            context,
                                            title: Text("Switch Task"),
                                            child: Column(
                                              children: <Widget>[
                                                Text("Possible task types"),
                                                Divider(),
                                                FlatButton(
                                                  child: Text("Pick Up from Customer"),
                                                  onPressed: (){
                                                    Navigator.of(context).pop(DemoTasks.pickupFromClientPu);
                                                  },
                                                ),
                                                Divider(),
                                                FlatButton(
                                                  child: Text("Pick Up from Customer\n(Without pickup bags)"),
                                                  onPressed: (){
                                                    Navigator.of(context).pop(DemoTasks.pickupFromClient);
                                                  },
                                                ),
                                                Divider(),
                                                FlatButton(
                                                  child: Text("Drop Off to Customer"),
                                                  onPressed: (){
                                                    Navigator.of(context).pop(DemoTasks.deliverToClient);
                                                  },
                                                ),
                                                Divider(),
                                                FlatButton(
                                                  child: Text("Pick Up from Warehouse\n(Without pickup bags)"),
                                                  onPressed: (){
                                                    Navigator.of(context).pop(DemoTasks.laundromatPickup);
                                                  },
                                                ),
                                                Divider(),
                                                FlatButton(
                                                  child: Text("Pick Up from Warehouse"),
                                                  onPressed: (){
                                                    Navigator.of(context).pop(DemoTasks.laundromatPickupPu);
                                                  },
                                                ),
                                                Divider(),
                                                FlatButton(
                                                  child: Text("Drop Off to Warehouse\n(Without pickup bags)"),
                                                  onPressed: (){
                                                    Navigator.of(context).pop(DemoTasks.laundromatDropoff);
                                                  },
                                                ),
                                                Divider(),
                                                FlatButton(
                                                  child: Text("Drop Off to Warehouse"),
                                                  onPressed: (){
                                                    Navigator.of(context).pop(DemoTasks.laundromatDropoffPu);
                                                  },
                                                ),
                                                Divider(),
                                                FlatButton(
                                                  child: Text("Go to Location"),
                                                  onPressed: (){
                                                    Navigator.of(context).pop(DemoTasks.gotoLocation);
                                                  },
                                                ),
                                                Divider(),
                                                FlatButton(
                                                  child: Text("Batched"),
                                                  onPressed: (){
                                                    Navigator.of(context).pop(DemoTasks.batched);
                                                  },
                                                ),
                                              ],
                                            ),
                                          );

                                          BlocProvider.of<HttpClientBloc>(context).add(HttpClientSetDemoTask(nextTask));
                                        },
                                      ),
                                    ]
                                  : []) +
                              [
                                DrawerMenu(
                                  child: DrawerMenuItem(
                                    leading: ColorFiltered(
                                      colorFilter: const ColorFilter.mode(const Color(0xFF232456), BlendMode.srcIn),
                                      child: Image.asset('assets/images/menu-logout.png'),
                                    ),
                                    title: Text(S.of(context).drawerLogout),
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<HttpClientBloc>(context).add(HttpClientDemo(false));
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
                      )));
        },
      );
    });
  }
}
