import 'dart:io';

import 'package:bynextcourier/bloc/location_tracker/location_tracker_bloc.dart';
import 'package:bynextcourier/bloc/task/task_bloc.dart';
import 'package:bynextcourier/constants.dart';
import 'package:bynextcourier/helpers/task_utils.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:bynextcourier/router.dart';
import 'package:bynextcourier/view/animated_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerPickupStep3 extends StatefulWidget {
  final Task task;

  const CustomerPickupStep3({Key key, this.task}) : super(key: key);

  @override
  _CustomerPickupStep3State createState() => _CustomerPickupStep3State();
}

class _CustomerPickupStep3State extends State<CustomerPickupStep3> {
  Task _task;
  File _image;

  @override
  void initState() {
    _task = widget.task;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, taskState) {
        final _task = taskState.task;
        return Scaffold(
        appBar: AppBar(
          bottom: bottomPlaceholder(taskState.rootTask != null),
        ),
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
                            image: _image != null
                              ? FileImage(
                              _image,
                            )
                              : NetworkImage(
                              "$mediaUrl${_task.meta.buildingImgUrl}",
                            ),
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(imageRoute, arguments: _image == null ? CachedNetworkImageProvider("$mediaUrl${_task.meta.buildingImgUrl}") : _image);
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
                                    _task.meta.userImage,
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
                              child: Image.asset(
                                "assets/images/camera-btn.png",
                              ),
                              onPressed: getImage,
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
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 0.0,
                                  horizontal: 15
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Image.asset(
                                        "assets/images/doorman-icon.png",
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text("Doorman"),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    IconButton(
                                      icon: Image.asset(
                                        _task.location.doorman ?? false ?
                                        "assets/images/checkbox-grey-checked.png" : "assets/images/checkbox-grey-unchecked.png",
                                        color: Colors.black,
                                      ),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {},
                                    ),
                                  ],
                                ),

//                                    child: ListTile(
//                                      contentPadding: EdgeInsets.zero,
//                                      leading: Icon(Icons.account_box),
//                                      title: Text("Doorman"),
//                                      trailing: IconButton(
//                                        icon: Icon(Icons.check_circle_outline),
//                                        padding: EdgeInsets.zero,
//                                        onPressed: (){},
//                                      ),
//                                    )
                              ),
                              Divider(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 0.0,
                                  horizontal: 15
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Image.asset(
                                        "assets/images/elevator-icon.png",
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text("Elevator"),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    IconButton(
                                      icon: Image.asset(
                                        _task.location.elevator ?? false ?
                                        "assets/images/checkbox-grey-checked.png" : "assets/images/checkbox-grey-unchecked.png",
                                        color: Colors.black,
                                      ),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 0.0,
                                  horizontal: 15
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Image.asset(
                                        "assets/images/bldg-floor-yes.png",
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text("Floor"),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    IconButton(
                                      icon: Stack(
                                        children: <Widget>[
                                          Align(
                                            child: Image.asset(
                                              "assets/images/checkbox-grey-unchecked.png",
                                              color: Colors.black,
                                            ),
                                          ),
                                          Align(
                                            child: Text((_task.location.floor ?? 0).toString())
                                          )
                                        ],
                                      ),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 0.0,
                                  horizontal: 15
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Image.asset(
                                        "assets/images/address-notes-icon.png",
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text("Address Notes"),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    IconButton(
                                      icon: Image.asset(
                                        "assets/images/button-add-white.png",
                                        color: Colors.black,
                                      ),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
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
      },
    );
  }

  Future getImage() async {
    final pickedFile = await getPhoto();
    printLabel('getImage pickedFile.path: ${pickedFile?.path}', 'TaskGoToLocationStep2Screen');
    setState(() {
      _image = pickedFile?.path != null ? File(pickedFile?.path) : null;
    });
  }
}
