import 'dart:ui';

import 'package:bynextcourier/bloc/payment_bloc.dart';
import 'package:bynextcourier/model/shift.dart';
import 'package:bynextcourier/view/app_bar_logo.dart';
import 'package:bynextcourier/view/custom_progress_indicator.dart';
import 'package:bynextcourier/view/salary_list_item.dart';
import 'package:bynextcourier/view/salary_list_item_footer.dart';
import 'package:bynextcourier/view/salary_list_rate_employee_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MySalaryScreen extends StatelessWidget {
  showPicker(BuildContext context) {
    var paymentBloc = BlocProvider.of<PaymentBloc>(context);

    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          int index = 0;

          return Column(
            children: <Widget>[
              FlatButton(
                child: Text("Select"),
                onPressed: () {
                  paymentBloc.add(GetPayment(periodId: paymentBloc.state.paymentPeriods[index].id));
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
                  children: paymentBloc.state.paymentPeriods.map((el) => Text(el.name)).toList(),
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
        builder: (context, state) {
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
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                            padding: EdgeInsets.all(3),
                            child: CircleAvatar(
                              radius: 50,
                              child: FittedBox(
                                child: Text(
                                  "\$" + state.payment?.totalPayment.toString(),
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 30, color: Colors.blue),
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
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                            padding: EdgeInsets.all(3),
                            child: CircleAvatar(
                              radius: 40,
                              child: FittedBox(
                                child: Text(
                                  state.payment?.numberOfShifts.toString(),
                                  style: TextStyle(fontSize: 30, color: Colors.blue),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "Shifts",
                          ),
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
                    onTap: () {
                      showPicker(context);
                    },
                  ),
                  buildColumn(state),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildColumn(PaymentState state) {
    if (state.payment.rateSystem == RateSystem.DELIVERY_COURIER_PAYMENT_EMPLOYEE_FIXED_RUN_COST ||
        state.payment.rateSystem == RateSystem.DELIVERY_COURIER_PAYMENT_EMPLOYEE) {
      return Column(
        children: <Widget>[
          Column(
            children: state.payment.shiftsDetails.map((el) => SalaryListRateEmployeeItem(el)).toList(),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              SalaryListItemFooter(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Text('TOTAL BEFORE TAX:')),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Text(
                      "\$" + state.payment?.totalPayment.toString(),
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                    'This information is only an ESTIMATE. Your final numbers will be provided and calculated by Gusto on your weekly paycheck.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                    )),
              )
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: state.payment.shiftsDetails.map((el) => SalaryListItem(el)).toList(),
      );
    }
  }
}
