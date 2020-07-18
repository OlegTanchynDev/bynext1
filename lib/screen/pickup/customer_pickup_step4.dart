import 'dart:async';

import 'package:bynextcourier/bloc/location_tracker/location_tracker_bloc.dart';
import 'package:bynextcourier/bloc/task/task_bloc.dart';
import 'package:bynextcourier/constants.dart';
import 'package:bynextcourier/helpers/task_utils.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/router.dart';
import 'package:bynextcourier/view/animated_button.dart';
import 'package:bynextcourier/view/app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerPickupStep4 extends StatefulWidget {
  @override
  _CustomerPickupStep4State createState() => _CustomerPickupStep4State();
}

class _CustomerPickupStep4State extends State<CustomerPickupStep4> {
  Timer _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, jobState) {
        if (jobState is ReadyTaskState) {
          return Scaffold(
            appBar: AppBar(
              title: AppBarTitle(task: jobState.task),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "No Show",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {},
                )
              ],
              bottom: bottomPlaceholder(jobState.rootTask != null),
            ),
            body: SafeArea(
              child: Container(
//                padding:
//                    EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 14),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        FlatButton(
                          padding: EdgeInsets.zero,
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  "$mediaUrl${jobState.task.meta
                                    .buildingImgUrl}"),
                                fit: BoxFit.cover
                              )
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed(imageRoute, arguments: "$mediaUrl${jobState.task.meta.buildingImgUrl}");
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 15,
                            top: 150,
                          ),
                          height: 80,
                          alignment: Alignment.bottomCenter,
                          child: Row(
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
                                        jobState.task.meta.userImage,
                                      ),
                                    )
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Text.rich(customerName(jobState?.task)),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    height: 39,
                                    width: 39,
                                    child: FlatButton(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.zero,
                                      child: Image.asset("assets/images/camera-btn.png",
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                  SizedBox(
                                    height: 13,
                                  ),
                                  Container(
                                    height: 28,
                                    width: 28,
                                    child: FlatButton(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.zero,
                                      child: Image.asset(
                                        "assets/images/call-icon.png",
                                        color: Colors.black,
                                      ),
                                      onPressed: () async {
                                        var result = await showContactsDialog(context, jobState.task, _timer);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20).copyWith(
                          bottom: 14),
                        child: Column(
                          children: <Widget>[

//                    Offstage(
//                      offstage: !jobState.task.meta.isBusinessAccount,
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          Text('Business Account'),
//                          SizedBox(
//                            width: 5,
//                          ),
//                          IconButton(
//                            icon: Image.asset(
//                              'assets/images/business.png',
//                              color: Color(0xFF403D9C),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme
                                    .of(context)
                                    .dividerTheme
                                    .color)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 9.0,
                                      horizontal: 15
                                    ),
                                    child: Text(
                                      jobState.task.location.street + " - " +
                                        jobState.task.location.streetLine2)),
                                  Divider(),
                                  FlatButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: (){
                                      Navigator.of(context).pushNamed(taskPickupFromClientStep3Route);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 9.0,
                                        horizontal: 15
                                      ),
                                      child: Text(
                                        "Doorman Building - ${jobState.task
                                          .location.doorman ?? "Unknown"}, " +
                                          "${jobState.task.location.floor ??
                                            "Unknown"} Floor, " +
                                          "${jobState.task.location.elevator ??
                                            "Unknown"} Elevator.",
                                        textAlign: TextAlign.center,
                                      )
                                    ),
                                  ),
                                  Divider(),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 9.0,
                                      horizontal: 15
                                    ),
                                    child: Text(
                                      getTaskCleaningOptions(jobState.task)
                                        .join(", "))
                                  ),
                                ],
                              )
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme
                                    .of(context)
                                    .dividerTheme
                                    .color)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 9.0,
                                      horizontal: 15
                                    ),
                                    child: Text(
                                      (jobState.task.location.notes ?? "")
                                        .length > 0 ? jobState.task.location
                                        .notes : "No Address Notes")),
                                  Divider(),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 9.0,
                                      horizontal: 15
                                    ),
                                    child: Text(
                                      (jobState.task.notes ?? "").length > 0
                                        ? jobState.task.notes
                                        : "No Pickup Notes",
                                      textAlign: TextAlign.center,
                                    )
                                  ),
                                ],
                              )
                            ),
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
                                  child: Text("Picked Up From Customer >>"),
                                  onHorizontalDragUpdate: (details) {
                                    if (details.primaryDelta > 40) {
                                      print("Drag right");
                                      Navigator.of(context).pushNamed(taskPickupFromClientStep5Route);
                                    }
                                  },
                                  condition: locationState
                                    .userArrivedAtDestinationLocation,
                                );
                              }
                            )
                          ],
                        )
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
