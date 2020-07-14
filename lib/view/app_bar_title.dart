import 'package:bynextcourier/helpers/task_utils.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final Task task;

  const AppBarTitle({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(taskAppBarTitle(task)),
        DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyText2,
          child: Text(taskAppBarSubtitle(task)),
        )
      ],
    );
  }

}