import 'package:bynextcourier/view/app_bar_title.dart';
import 'package:flutter/material.dart';

class BatchedOrdersScreen extends StatefulWidget {
  BatchedOrdersScreen({Key key}) : super(key: key);

  @override
  _BatchedOrdersScreenState createState() => _BatchedOrdersScreenState();
}

class _BatchedOrdersScreenState extends State<BatchedOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Batched Orders')),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
