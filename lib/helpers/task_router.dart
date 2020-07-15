import 'package:bynextcourier/bloc/arrival_bloc.dart';
import 'package:bynextcourier/bloc/task/task_bloc.dart';
import 'package:bynextcourier/generated/l10n.dart';
import 'package:bynextcourier/model/task.dart';
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
}
