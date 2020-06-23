import 'package:flutter/material.dart';

class DrawerMenuItem extends StatelessWidget {
  final Widget leading;
  final Widget title;

  const DrawerMenuItem({Key key, this.leading, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 55,
          height: 40,
          padding: EdgeInsets.only(left: 10.0),
          child: leading,
        ),
        DefaultTextStyle(
          child: title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }
}
