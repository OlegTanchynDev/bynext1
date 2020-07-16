import 'package:bynextcourier/bloc/barcode_details_bloc.dart';
import 'package:bynextcourier/bloc/location_tracker/location_tracker_bloc.dart';
import 'package:bynextcourier/bloc/task/task_bloc.dart';
import 'package:bynextcourier/helpers/task_utils.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/model/barcode_details.dart';
import 'package:bynextcourier/view/animated_button.dart';
import 'package:bynextcourier/view/app_bar_title.dart';
import 'package:bynextcourier/view/bags_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerPickupStep5 extends StatefulWidget {
  @override
  _CustomerPickupStep5State createState() => _CustomerPickupStep5State();
}

class _CustomerPickupStep5State extends State<CustomerPickupStep5> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, jobState) {
        if (jobState is ReadyTaskState) {
          return Scaffold(
            appBar: AppBar(
              title: AppBarTitle(task: jobState.task),
              bottom: bottomPlaceholder(jobState.rootTask != null),
            ),
            body: SafeArea(
              child: Container(
//                padding: EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: 80,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                    jobState.task.meta.userImage,
                                  ),
                                )
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: 3,
                              left: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  jobState.task.location.street + ", " +
                                  jobState.task.location.streetLine2
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
//                                color: Colors.green,
                                  child: Text.rich(customerName(jobState?.task)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
//                      child: BlocBuilder<BarcodeDetailsBloc, BarcodeDetailsBlocState>(
                      child: BlocConsumer<BarcodeDetailsBloc, BarcodeDetailsBlocState>(
                        listener: (context, barcodeState) async {
                          if(barcodeState.error != null){
                            await showCustomDialog2(
                              context,
                              title: Text("Invalid barcode"),
//                              child: Text("There was an error processing your request, please try again"),
                              child: Text("${barcodeState.error.errors['error']}"),
                              buttons: [
                                FlatButton(
                                  child: Text("OK"),
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          }
                        },
                        builder: (context, barcodeState) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 20)
                              .copyWith(bottom: 14),
                            child: Column(
                              children: <Widget>[
                                BagsList(
                                  barcodes: barcodeState.barcodes,
                                ),
                              ] +
                                (barcodeState.notes as List<OrderNote>).map((
                                  e) =>
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme
                                          .of(context)
                                          .dividerTheme
                                          .color
                                      )
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 40,
                                          height: 40,
                                          padding: EdgeInsets.all(1),
                                          child: Image.network(
                                            e.image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(e.text),
                                      ],
                                    ),
                                  )).toList()
                                + [
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                    ),
                                  ),
                                  BlocBuilder<
                                    LocationTrackerBloc,
                                    LocationTrackerBaseState>(
                                    builder: (context, locationState) {
                                      return AnimatedButton(
                                        child: Text(
                                          "Picked Up From Customer >>"),
                                        onHorizontalDragUpdate: (details) {
                                          if (details.primaryDelta > 40) {
                                            print("Drag right");
                                          }
                                        },
                                        condition: locationState
                                          .userArrivedAtDestinationLocation,
                                      );
                                    }
                                  )

                                ],
                            ),
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: Text("No task selected"),
          );
        }
      },
    );
  }
}
