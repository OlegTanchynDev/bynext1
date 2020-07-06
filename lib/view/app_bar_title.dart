import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final Widget title;
  final Widget subtitle;

  const AppBarTitle({Key key, this.title, this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        title,
        DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyText2,
          child: subtitle,
        )
      ],
    );
  }

}