import 'package:bynextcourier/bloc/payment_bloc.dart';
import 'package:bynextcourier/view/app_bar_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MySalaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarLogo(),
        centerTitle: true,
        actions: <Widget>[const SizedBox(width: 50)],
      ),
      body: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state){
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Align(child: Text("Current Period")),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    CircleAvatar(
                      radius: 50,
                      child: Text("\$" + state.payment?.totalPayment.toString()),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    CircleAvatar(
                      radius: 40,
                      child: Text(state.payment?.numberOfShifts.toString()),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
}