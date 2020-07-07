import 'package:bynextcourier/view/app_bar_title.dart';
import 'package:flutter/material.dart';

class CustomerDeliveryStep1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(title: Text('Delivery Job'), subtitle: Text('10:00 PM - 11:00 PM'))
      ),
    );
  }
}