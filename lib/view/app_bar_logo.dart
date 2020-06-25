import 'package:flutter/material.dart';

class AppBarLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 30,
        child: Image(image: AssetImage('assets/images/logo.png')),
      );
}
