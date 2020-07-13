import 'package:bynextcourier/bloc/location_tracker/location_tracker_bloc.dart';
import 'package:bynextcourier/bloc/task/task_bloc.dart';
import 'package:bynextcourier/constants.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/view/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerPickupEdit extends StatefulWidget {
  @override
  _CustomerPickupEditState createState() => _CustomerPickupEditState();
}

class _CustomerPickupEditState extends State<CustomerPickupEdit> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, jobState) {
        if (jobState is ReadyTaskState) {
          return Scaffold(
            appBar: AppBar(),
            body: SafeArea(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        FlatButton(
                          padding: EdgeInsets.zero,
                          child: Container(
                            height: 400,
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

                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 15,
                            top: 340,
                          ),
                          height: 60,
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 30,
                                child: Container(
                                  width: 59,
                                  height: 59,
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
                              Expanded(
                                child: Container(),
                              ),
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

                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 20,
                              ),
                              child: Text("Click to add / remove information")
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
                                  child: Text("Save Building Info >>"),
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
