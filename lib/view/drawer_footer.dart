import 'package:flutter/material.dart';

class DrawerFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Referral Code:'),
        Text('CHENAT10'),
        SizedBox(height: 4),
        Text('Version: 2.8.5'),
      ],
    );
  }
}
