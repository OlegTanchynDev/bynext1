import 'package:flutter/material.dart';

class DrawerFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Referral Code:\nCHENAT10'),
          SizedBox(height: 4,),
          Text('Version: 2.8.5')
        ],
      ),
    );
  }
}
