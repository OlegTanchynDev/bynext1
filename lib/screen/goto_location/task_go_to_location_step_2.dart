import 'dart:ui';

import 'package:bynextcourier/bloc/http_client_bloc.dart';
import 'package:bynextcourier/bloc/location_tracker/location_tracker_bloc.dart';
import 'package:bynextcourier/bloc/start_job/start_job_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/constants.dart';
import 'package:bynextcourier/generated/l10n.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:bynextcourier/repository/tasks_repository.dart';
import 'package:bynextcourier/router.dart';
import 'package:bynextcourier/view/app_bar_logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class TaskGoToLocationStep2Screen extends StatefulWidget {
  @override
  _TaskGoToLocationScreenState createState() => _TaskGoToLocationScreenState();
}

class _TaskGoToLocationScreenState extends State<TaskGoToLocationStep2Screen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var blocState = (BlocProvider.of<StartJobBloc>(context).state as ReadyToStartJobState);
      if (blocState.task.meta.isEarly) {
        showNotesPopup(context);
      }
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
      body: SafeArea(
        child: BlocBuilder<StartJobBloc, StartJobState>(
          builder: (BuildContext context, state) {
            var task = (state as ReadyToStartJobState).task;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Stack(
                  overflow: Overflow.visible,
                  alignment: Alignment.bottomLeft,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: buildImgContainer(task, context),
                    ),
                    buildRow(task, context),
                  ],
                ),
                buildTable(task, context),
                Expanded(child: SizedBox()),
                buildButton(context, task),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildImgContainer(Task task, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    var buildingImgUrl = task.meta.buildingImgUrl != null ? '$mediaUrl${task.meta.buildingImgUrl}' : 'http://blank';
    return GestureDetector(
      onTap: task.meta.buildingImgUrl != null?() {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  title: AppBarLogo(),
                  centerTitle: true,
                ),
                body: Center(
                    child: Container(
                        width: screenWidth,
                        height: screenWidth,
                        color: Colors.grey[300],
                        child: Image.network(
                          buildingImgUrl,
                          fit: BoxFit.cover,
                        ))),
              );
            },
          ),
        );
      }:null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
        ),
        height: 150,
        width: screenWidth,
        child: Image.network(
          buildingImgUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<void> showNotesPopup(BuildContext context) async {
    return showCustomDialog<void>(context,
        title: 'Please Note',
        message:
            'You have arrived early to this task. Proceed to the next step only if the dispatcher approved. \n Proceeding without approval may result in grade reduction.',
        buttons: [
          IconButton(
            icon: ColorFiltered(
              colorFilter: const ColorFilter.mode(const Color(0xFF403D9C), BlendMode.srcIn),
              child: Image.asset('assets/images/checkbox-grey-checked.png'),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ]);
  }

  Row buildRow(Task task, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 0, left: 9),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(1),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/header-supplies.png'),
              radius: 36,
            ),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text('${task.meta?.jobTitle}'),
        )),
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 15, right: 12),
              child: SizedBox(
                height: 35,
                width: 35,
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.all(0),
                  icon: Image.asset('assets/images/camera-btn.png'),
                  iconSize: 35,
                  onPressed: () {
                    //launchMaps(context, task.location.lat, task.location.lng);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: SizedBox(
                height: 28,
                width: 28,
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.all(0),
                  icon: Image.asset(
                    'assets/images/call-icon.png',
                    color: Theme.of(context).colorScheme.secondaryVariant,
                  ),
                  iconSize: 28,
                  onPressed: () {
                    //launchMaps(context, task.location.lat, task.location.lng);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildButton(BuildContext context, Task task) {
    return BlocBuilder<LocationTrackerBloc, LocationTrackerBaseState>(
      builder: (BuildContext context, LocationTrackerBaseState state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
          child: RaisedButton(
            child: Text('PLEASE TAKE A PICTURE'),
            onPressed: () async {},
          ),
        );
      },
    );
  }

  Padding buildTable(Task task, BuildContext context) {
    final borderSide = BorderSide(color: Theme.of(context).dividerTheme.color);
    final notes = task
        .notes; // ?? 'Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 65),
                child: Text(
                  '${DateFormat.jm().format(task.actionTime)}',
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerTheme.color)),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                          width: 33,
                          height: 33,
                          child: Image.asset(
                            'assets/images/warning-icon.png',
//                            color: Theme.of(context).colorScheme.secondaryVariant,
                          )),
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.all(9.0),
                              child: Text(
                                task.location.name,
                                textAlign: TextAlign.center,
                              ))),
                      SizedBox(width: 33, height: 33, child: Image.asset('assets/images/warning-icon.png')),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(border: Border(left: borderSide, bottom: borderSide, right: borderSide)),
                  child: Padding(
                      padding: EdgeInsets.all(9.0),
                      child: Text(
                        notes ?? 'No notes',
                        textAlign: TextAlign.justify,
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
