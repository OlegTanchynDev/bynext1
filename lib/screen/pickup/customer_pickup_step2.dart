import 'package:bynextcourier/bloc/location_tracker/location_tracker_bloc.dart';
import 'package:bynextcourier/bloc/start_job/start_job_bloc.dart';
import 'package:bynextcourier/constants.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/view/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerPickupStep2 extends StatefulWidget {
  @override
  _CustomerPickupStep2State createState() => _CustomerPickupStep2State();
}

class _CustomerPickupStep2State extends State<CustomerPickupStep2> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartJobBloc, StartJobState>(
      builder: (context, jobState) {
        if (jobState is ReadyToStartJobState) {
          return Scaffold(
            appBar: AppBar(),
            body: SafeArea(
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 14),
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
                                image: NetworkImage("$mediaUrl${jobState.task.meta.buildingImgUrl}"),
                                fit: BoxFit.cover
                              )
                            ),

                          ),
                          onPressed: (){

                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            top: 150,
                          ),
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
                                padding: EdgeInsets.only(
                                  bottom: 4
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Image.asset(
                                        "assets/images/heart-icon-fill.png",
                                        height: 25,
                                      ),
                                      padding: EdgeInsets.zero,
                                      alignment: Alignment.bottomCenter,
                                    ),
                                    Text(jobState?.task?.location?.name ?? ""),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),

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
                      height: 50,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).dividerTheme.color)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 9.0,
                                horizontal: 15
                              ),
                              child: Text(jobState.task.location.street + " - " + jobState.task.location.streetLine2)),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 9.0,
                                horizontal: 15
                              ),
                              child: Text(
                                "Doorman Building - ${jobState.task.location.doorman ?? "Unknown"}, " + "${jobState.task.location.floor ?? "Unknown"} Floor, " + "${jobState.task.location.elevator ?? "Unknown"} Elevator.",
                              textAlign: TextAlign.center,
                              )
                            ),
                            Divider(),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 9.0,
                                  horizontal: 15
                                ),
                                child: Text(getTaskCleaningOptions(jobState.task).join(", "))
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
                          color: Theme.of(context).dividerTheme.color)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 9.0,
                              horizontal: 15
                            ),
                            child: Text((jobState.task.location.notes ?? "").length > 0 ? jobState.task.location.notes : "No Address Notes")),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 9.0,
                              horizontal: 15
                            ),
                            child: Text(
                              (jobState.task.notes ?? "").length > 0 ? jobState.task.notes : "No Pickup Notes",
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
                    BlocBuilder<LocationTrackerBloc, LocationTrackerBaseState>(
                      builder: (context, locationState) {
                        return AnimatedButton(
                          child: Text("Picked Up From Customer >>"),
                          onHorizontalDragUpdate: (details) {
                            if (details.primaryDelta > 40) {
                              print("Drag right");
                            }
                          },
                          condition: locationState.userArrivedAtDestinationLocation,
                        );
                      }
                    )
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

//  @override
//  void initState() {
//    final jobState = BlocProvider.of<StartJobBloc>(context).state;
//    if (jobState is ReadyToStartJobState && jobState.task.meta.firstOrder) {
//      WidgetsBinding.instance.addPostFrameCallback((_) async {
//        await Future.delayed(Duration(
//          milliseconds: 600,
//        ));
//        await showNoBarrierDialog(context,
//          child: Column(
//            children: <Widget>[
//              IconButton(
//                icon: Image.asset(
//                  "assets/images/heart-icon.png",
//                  color: Colors.black,
//                ),
//              ),
//              Text("First time customer!"),
//            ],
//          )).timeout(Duration(seconds: 2), onTimeout: () {
//          Navigator.of(context).pop();
//        });
//      });
//    }
//
//    super.initState();
//  }
}
