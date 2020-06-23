import 'package:flutter/material.dart';

class DrawerFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(child: Text('Referral Code:')),
        Expanded(child: Text('CHENAT10')),
        SizedBox(height: 4),
        Expanded(child: Text('Version: 2.8.5')),
      ],
    );
  }
}
