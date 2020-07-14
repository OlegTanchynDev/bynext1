import 'package:bynextcourier/model/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

InlineSpan customerName(Task task) {
  String contactName = (task.meta?.firstOrder == true ? '❤️ ' : '') + task.contact.name;
  if (task.meta?.reserve == true) {
    return TextSpan(children: [
      TextSpan(text: contactName),
      TextSpan(text: '     RESERVE MEMBER', style: TextStyle(color: Color.fromRGBO(207, 181, 106, 1.0))),
    ]);
  } else {
    return TextSpan(text: contactName);
  }
}

String taskShortDescription(Task task) {
  if (task.type == CardType.COURIER_TASK_TYPE_PICKUP_FROM_CLIENT) {
    if (task.location.latchBuilding == true) {
      return 'Unattended Pickup';
    } else if (task.meta.pickupFromDoorman == true) {
      return 'Pickup from Doorman';
    } else {
      return 'Pickup from Customer';
    }
  } else {
    if (task.meta.deliveryToDoorman == true) {
      return 'Delivery to Doorman';
    } else {
      return 'Delivery to Customer';
    }
  }
}

String taskAppBarTitle(Task task) {
  switch(task.type) {
    case CardType.COURIER_TASK_TYPE_PICKUP_FROM_CLIENT:
      return task.linkedTasks.length > 0 ? 'Batched Orders' : 'Pickup Job';
    case CardType.COURIER_TASK_TYPE_DELIVER_TO_CLIENT:
      return task.linkedTasks.length > 0 ? 'Batched Orders' : 'Delivery Job';
    case CardType.COURIER_TASK_TYPE_LAUNDROMAT_PICKUP:
      return 'Pickup from Dropshop';
    case CardType.COURIER_TASK_TYPE_LAUNDROMAT_DROPOFF:
      return 'Drop off to Dropshop';
    default:
      return '';
  }
}

String taskAppBarSubtitle(Task task) {
  switch(task.type) {
    case CardType.COURIER_TASK_TYPE_PICKUP_FROM_CLIENT:
      return task.linkedTasks.length == 0 ? taskTimeInterval(task) : null;
    case CardType.COURIER_TASK_TYPE_DELIVER_TO_CLIENT:
      return task.linkedTasks.length == 0 ? taskTimeInterval(task) : null;
    default:
      return '';
  }
}

String taskTimeInterval(Task task) {
  if (task.type == CardType.COURIER_TASK_TYPE_PICKUP_FROM_CLIENT) {
    if (task.meta?.pickupDateTime != null && task.meta?.pickupDateTimeEnd != null) {
      return '${DateFormat.jm().format(task.meta?.pickupDateTime)} - ${DateFormat.jm().format(task.meta?.pickupDateTimeEnd)}';
    } else {
      return '';
    }
  } else {
    if (task.meta?.deliveryDateTime != null && task.meta?.deliveryDateTimeEnd != null) {
      return '${DateFormat.jm().format(task.meta?.deliveryDateTime)} - ${DateFormat.jm().format(task.meta?.deliveryDateTimeEnd)}';
    } else {
      return '';
    }
  }
}
