import 'package:bynextcourier/bloc/payment_bloc.dart';
import 'package:bynextcourier/view/app_bar_logo.dart';
import 'package:bynextcourier/view/custom_progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MySalaryScreen extends StatelessWidget {
  showPicker(BuildContext context) {
    final paymentBloc = BlocProvider.of<PaymentBloc>(context);
    var items = List.from(paymentBloc.state.payment.paymentPeriods);
    var currentItem = paymentBloc.state.payment.currentPaymentPeriod;
    items.add(currentItem);
    items.sort((a, b) => b.name.compareTo(a.name));

    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        int index = 0;

        return Column(
          children: <Widget>[
            FlatButton(
              child: Text("Select"),
              onPressed: (){
                paymentBloc.add(GetPayment(periodId: items[index].id));
                Navigator.of(ctx).pop();
              },
            ),
            Expanded(
              child: CupertinoPicker(
//          backgroundColor: Colors.white,
                onSelectedItemChanged: (value) {
                  index = value;
                },
                itemExtent: 32.0,
                children: items.map((el) => Text(el.name)).toList(),
              ),
            ),
          ],
        );
      });
  }

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
          if (state.payment == null) {
            return CustomProgressIndicator();
          } else {
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
                      Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue
                            ),
                            padding: EdgeInsets.all(3),
                            child: CircleAvatar(
                              radius: 50,
                              child: FittedBox(
                                child: Text(
                                  "\$" + state.payment?.totalPayment.toString(),textScaleFactor: 1,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.blue
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text("Earned"),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue
                            ),
                            padding: EdgeInsets.all(3),
                            child: CircleAvatar(
                              radius: 40,
                              child: FittedBox(
                                child: Text(
                                  state.payment?.numberOfShifts.toString(),
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.blue
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text("Shifts",),
                        ],
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          state.payment.currentPaymentPeriod.name,
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    ),
                    onTap: (){
                      showPicker(context);
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}