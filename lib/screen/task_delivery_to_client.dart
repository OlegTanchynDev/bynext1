import 'package:bynextcourier/view/app_bar_logo.dart';
import 'package:bynextcourier/view/app_bar_title.dart';
import 'package:flutter/material.dart';

class TaskDeliveryToClientScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(title: Text('Delivery Job'), subtitle: Text('8:00 PM - 9:00 PM')),
      ),
      body: Center(child: Text('TaskDeliveryToClientScreen')),
    );
  }

}