import 'package:bynextcourier/bloc/arrival_bloc.dart';
import 'package:bynextcourier/bloc/barcode_details_bloc.dart';
import 'package:bynextcourier/bloc/http_client_bloc.dart';
import 'package:bynextcourier/bloc/task/task_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/generated/l10n.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:bynextcourier/repository/barcode_details_repository.dart';
import 'package:bynextcourier/screen/delivery_to_client/customer_delivery_step3.dart';
import 'package:bynextcourier/screen/goto_location/task_go_to_location.dart';
import 'package:bynextcourier/screen/goto_location/task_go_to_location_step_2.dart';
import 'package:bynextcourier/screen/laundromat_dropoff/laundromat_dropoff_step1.dart';
import 'package:bynextcourier/screen/laundromat_pickup/laundromat_pickup_step1.dart';
import 'package:bynextcourier/screen/pickup/customer_pickup_step1.dart';
import 'package:bynextcourier/screen/pickup/customer_pickup_step1_widget.dart';
import 'package:bynextcourier/screen/pickup/customer_pickup_step3.dart';
import 'package:bynextcourier/screen/pickup/customer_pickup_step4.dart';
import 'package:bynextcourier/screen/pickup/customer_pickup_step5.dart';
import 'package:bynextcourier/screen/supplies/pickup_supplies_step1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../router.dart';
import 'utils.dart';

class TaskRouter {
  static void listener(context, taskState) async {
    if (taskState is ReadyTaskState) {
      if (taskState.switchToNewTask) {
        await showCustomDialog2(context,
            title: Text(S.of(context).taskChangedTitle),
            child: Text(S.of(context).taskChangedMessage),
            buttons: [FlatButton(child: Text(S.of(context).ok), onPressed: () => Navigator.of(context).pop())]);
      }

      switch (taskState.task.type) {
        case CardType.COURIER_TASK_TYPE_GOTO_LOCATION:
          Navigator.of(context).pushNamed(taskGoToLocationRoute);
          break;
        case CardType.COURIER_TASK_TYPE_PICKUP_FROM_CLIENT:
        case CardType.COURIER_TASK_TYPE_DELIVER_TO_CLIENT:
          if (taskState.task.linkedTasks?.isEmpty ?? true) {
            Navigator.of(context).pushNamed(taskPickupFromClientRoute);
          } else {
            Navigator.of(context).pushNamed(taskBatchedOrdersRoute);
          }
          break;
        case CardType.COURIER_TASK_TYPE_PICKUP_SUPPLIES:
          Navigator.of(context).pushNamed(taskPickupSuppliesRoute);
          break;
        case CardType.COURIER_TASK_TYPE_LAUNDROMAT_PICKUP:
          Navigator.of(context).pushNamed(taskLaundromatPickupRoute);
          break;
        case CardType.COURIER_TASK_TYPE_LAUNDROMAT_DROPOFF:
          Navigator.of(context).pushNamed(taskLaundromatDropOffRoute);
          break;
        default:
          Navigator.of(context).pushNamed(webRoute, arguments: {'url': 'http://google.com', 'title': 'TEST'});
      }
    }
  }

  static void arrivalListener(BuildContext context, ArrivalState state) {
    if (state.arrived && state.task != null) {
      switch (state.task.type) {
        case CardType.COURIER_TASK_TYPE_GOTO_LOCATION:
          Navigator.of(context)
              .pushNamed(taskGoToLocationStep2Route)
              .whenComplete(() => context.bloc<ArrivalBloc>().add(ArrivalClearEvent()));
          break;
        case CardType.COURIER_TASK_TYPE_PICKUP_FROM_CLIENT:
          Navigator.of(context)
              .pushNamed(taskPickupFromClientStep4Route)
              .whenComplete(() => context.bloc<ArrivalBloc>().add(ArrivalClearEvent()));
          break;
        case CardType.COURIER_TASK_TYPE_DELIVER_TO_CLIENT:
          Navigator.of(context)
              .pushNamed(taskDeliverToClientStep3Route)
              .whenComplete(() => context.bloc<ArrivalBloc>().add(ArrivalClearEvent()));
          break;
      }
    }
  }

  static Route<dynamic> generateRoute(RouteSettings settings, Task task) {
    return MaterialPageRoute<void>(
    settings: settings,
    builder: (BuildContext context) {
    Widget page;
    switch (settings.name) {
      case taskGoToLocationRoute:
        page = TaskGoToLocationScreen();
        break;
      case taskGoToLocationStep2Route:
        page = TaskGoToLocationStep2Screen();
        break;
      case taskPickupFromClientRoute:
        page = CustomerPickupStep1Widget(task: task);
        break;
      case taskPickupFromClientStep4Route:
        page = CustomerPickupStep4();
        break;
      case taskPickupFromClientStep5Route:
        page = BlocProvider(
          create: (context) => BarcodeDetailsBloc()
            ..tokenBloc = context.bloc<TokenBloc>()
            ..httpClientBloc = context.bloc<HttpClientBloc>()
            ..taskBloc = context.bloc<TaskBloc>()
            ..repository = context.repository<BarcodeDetailsRepository>()
            ..add(GetBarcodeDetails()),
          child: CustomerPickupStep5(),
        );
        break;
      case taskPickupFromClientStep3Route:
        page = CustomerPickupStep3(
          task: settings.arguments,
        );
        break;
      case taskDeliverToClientStep3Route:
        page = BlocProvider(
          create: (context) => BarcodeDetailsBloc()
            ..tokenBloc = context.bloc<TokenBloc>()
            ..httpClientBloc = context.bloc<HttpClientBloc>()
            ..taskBloc = context.bloc<TaskBloc>()
            ..repository = context.repository<BarcodeDetailsRepository>()
            ..add(GetBarcodeDetails()),
          child: CustomerDeliveryStep3(),
        );
        break;
      default:
        page = Scaffold(
          appBar: AppBar(),
          body: Center(child: Text('No route defined for ${settings.name}')),
        );
    }
    return GestureDetector(onTap: () => FocusScope.of(context).requestFocus(new FocusNode()), child: page);
    });
  }
}
