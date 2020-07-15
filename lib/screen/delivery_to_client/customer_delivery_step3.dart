import 'package:barcode_scan/barcode_scan.dart';
import 'package:bynextcourier/bloc/barcode_details_bloc.dart';
import 'package:bynextcourier/bloc/task/task_bloc.dart';
import 'package:bynextcourier/helpers/task_utils.dart';
import 'package:bynextcourier/view/app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerDeliveryStep3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final task = BlocProvider.of<TaskBloc>(context).state.task;

    return Scaffold(
        appBar: AppBar(
          title: AppBarTitle(task: task),
        ),
        body: SafeArea(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              CircleAvatar(
                radius: 40,
                child: Container(
                  width: 79,
                  height: 79,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          task.meta.userImage,
                        ),
                      )),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    top: 3,
                    left: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(task.location.street + ", " + task.location.streetLine2),
                      SizedBox(
                        height: 5,
                      ),
                      Text.rich(customerName(task)),
                      RaisedButton(
                        child: Text('SCAN BARCODE'),
                        onPressed: () async {
                          var result = await BarcodeScanner.scan();
                          if (result.type == ResultType.Barcode) {
                            print('result.rawContent = ${result.rawContent}');
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Bags'),
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).buttonColor, border: Border.all(color: Colors.white, width: 1.0)),
                  padding: EdgeInsets.all(4),
                  child: Text('0', style: TextStyle(color: Colors.white))
              ),
            ],
          ),
              BlocBuilder<BarcodeDetailsBloc, BarcodeDetailsBlocState>(
                builder: (context, barcodeState) {
                  return ListView(

                  );
                },
              ),
        ])));
  }
}
