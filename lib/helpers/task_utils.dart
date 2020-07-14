import 'package:bynextcourier/model/task.dart';
import 'package:flutter/cupertino.dart';

InlineSpan customerName(Task task) {
  String contactName = (task.meta?.firstOrder == true ? '❤️ ' : '') + task.contact.name;
  if (task.meta?.reserve == true) {
    return TextSpan(
      children:[
        TextSpan(text: contactName),
        TextSpan(text: '     RESERVE MEMBER', style: TextStyle(color: Color.fromRGBO(207, 181, 106, 1.0))),
      ]
    );
  } else {
    return TextSpan(text: contactName);
  }
}

String pickupFromLabel(Task task) {}
