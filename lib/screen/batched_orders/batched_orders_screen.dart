import 'package:bynextcourier/bloc/arrival_bloc.dart';
import 'package:bynextcourier/bloc/http_client_bloc.dart';
import 'package:bynextcourier/bloc/location_tracker/location_tracker_bloc.dart';
import 'package:bynextcourier/bloc/task/task_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/constants.dart';
import 'package:bynextcourier/generated/l10n.dart';
import 'package:bynextcourier/helpers/task_router.dart';
import 'package:bynextcourier/helpers/task_utils.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:bynextcourier/repository/tasks_repository.dart';
import 'package:bynextcourier/router.dart';
import 'package:bynextcourier/screen/batched_orders/batched_order_tab.dart';
import 'package:bynextcourier/screen/pickup/customer_pickup_step1.dart';
import 'package:bynextcourier/view/app_bar_title.dart';
import 'package:bynextcourier/view/custom_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BatchedOrdersScreen extends StatefulWidget {
  BatchedOrdersScreen({Key key}) : super(key: key);

  @override
  _BatchedOrdersScreenState createState() => _BatchedOrdersScreenState();
}

class _BatchedOrdersScreenState extends State<BatchedOrdersScreen> {
  List<BatchedOrderTabItem> tabs = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      this.showPopup(context);
    });
    Task task = (BlocProvider.of<TaskBloc>(context).state as ReadyTaskState).task;

    for (var item in task.linkedTasks) {
      String tabTitle = _generateTabTitle(item);
      tabs.add(BatchedOrderTabItem(title: tabTitle, task: item));
    }
    super.initState();
  }

  String _generateTabTitle(Task task) {
    var tabTitle = '';
    if (task.type == CardType.COURIER_TASK_TYPE_PICKUP_FROM_CLIENT) {
      tabTitle = 'PICKUP';
    } else if (task.type == CardType.COURIER_TASK_TYPE_PICKUP_FROM_CLIENT) {
      tabTitle = 'DELIVERY';
    } else if (task.type == CardType.COURIER_TASK_TYPE_GOTO_LOCATION) {
      if (task.meta.runType == 0) {
        tabTitle = 'PICKUP';
      } else {
        tabTitle = 'DELIVERY';
      }
    }
    tabTitle += '\n' + task.location.streetLine2;
    tabTitle += '\n' + taskTimeInterval(task).replaceAll(new RegExp(r"\s+"), "");
    return tabTitle;
  }

  Future<void> showPopup(BuildContext context) async {
    return showCustomDialog<void>(context,
        title: 'Batched Orders',
        message: 'Please be aware that there are multiple orders in the same building.',
        buttons: [FlatButton(child: Text(S.of(context).ok), onPressed: () => Navigator.of(context).pop())]);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Batched Orders'),
          bottom: TabBar(
            labelColor: Colors.white,
            isScrollable: tabs.length > 2,
            unselectedLabelColor: Theme.of(context).primaryTextTheme.headline1.color,
            indicator: BoxDecoration(borderRadius: BorderRadius.circular(10), color: raisedButtonColor),
            tabs: tabs
                .map((tab) => CustomTab(
                      60,
                      child: Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(tab.title,
                              textAlign: TextAlign.center, softWrap: false, overflow: TextOverflow.fade),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: tabs.map((tab) {
            return buildLayout(tab);
          }).toList(),
        ),
      ),
    );
  }

  Widget buildLayout(BatchedOrderTabItem tab) {
    Task task = tab.task;
    Task batchTask = BlocProvider.of<TaskBloc>(context).state.task;
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (context) => TaskBloc()..add(SetTaskEvent(task, batchTask)),
          ),
          BlocProvider(
              create: (context) => ArrivalBloc()
                ..taskBloc = context.bloc<TaskBloc>()
                ..tokenBloc = context.bloc<TokenBloc>()
                ..httpClientBloc = context.bloc<HttpClientBloc>()
                ..locationTrackerBloc = context.bloc<LocationTrackerBloc>()
                ..repository = context.repository<TasksRepository>()),
        ],
        child: Navigator(
          onGenerateRoute: Router.generateRoute,
          initialRoute: TaskRouter.routeFromTask(task, forceNonBatched: true),
        ),
      ),
    );
  }
}
