import 'package:bynextcourier/view/app_bar_logo.dart';
import 'package:flutter/material.dart';

class ShiftsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarLogo(),
        centerTitle: true,
        actions: <Widget>[const SizedBox(width: 50)],
      ),
    );
  }
}