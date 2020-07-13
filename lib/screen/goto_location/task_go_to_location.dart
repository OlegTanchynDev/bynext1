import 'dart:ui';

import 'package:bynextcourier/bloc/http_client_bloc.dart';
import 'package:bynextcourier/bloc/location_tracker/location_tracker_bloc.dart';
import 'package:bynextcourier/bloc/task/task_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
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

class TaskGoToLocationScreen extends StatefulWidget {
  @override
  _TaskGoToLocationScreenState createState() => _TaskGoToLocationScreenState();
}

class _TaskGoToLocationScreenState extends State<TaskGoToLocationScreen> {
  GoogleMapController _controller;

//  BitmapDescriptor _markerIcon;

  @override
  Widget build(BuildContext context) {
//    _createMarkerImageFromAsset(context);
    return Scaffold(
      appBar: AppBar(
        title: AppBarLogo(),
        centerTitle: true,
        actions: <Widget>[const SizedBox(width: 50)],
      ),
      body: SafeArea(
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (BuildContext context, state) {
            var task = (state as ReadyTaskState).task;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Stack(
                  overflow: Overflow.visible,
                  alignment: Alignment.bottomLeft,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Container(
                        height: 150,
                        child: GoogleMap(
                          initialCameraPosition:
                          CameraPosition(target: LatLng(task.location.lat, task.location.lng), zoom: 14.0),
                          mapType: MapType.normal,
                          myLocationButtonEnabled: false,
                          onMapCreated: (GoogleMapController controller) {
                            setState(() {
                              _controller = controller;
                            });
                          },
                          markers: _createMarker(task.location),
                        ),
                      ),
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

  Row buildRow(Task task, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 12),
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
        Expanded(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text('${task.location.street}, ${task.location.streetLine2}'),
        )),
        Padding(
          padding: const EdgeInsets.only(bottom: 30, right: 18),
          child: SizedBox(
            height: 32,
            width: 32,
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: EdgeInsets.all(0),
              icon: Image.asset('assets/images/navigation-icon.png'),
              iconSize: 32,
              onPressed: () {
                launchMaps(context, task.location.lat, task.location.lng);
              },
            ),
          ),
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
            child: Text('Arrived at place >>'),
            onPressed: state.userArrivedAtDestinationLocation
                ? () async {
              final repository = RepositoryProvider.of<TasksRepository>(context);
              var httpClientState = BlocProvider
                  .of<HttpClientBloc>(context)
                  .state;
              final client = httpClientState.client;
              final token = BlocProvider
                  .of<TokenBloc>(context)
                  .state
                  .token;
              final location = state.location;
              var result;
              if (httpClientState.demo) {
                result = await repository.performArriveAtPlaceWithTaskID(
                    client, token, task.id);
              } else {
                result = await repository.performArriveAtPlaceWithTaskID(
                    client, token, task.id, location.latitude, location.longitude);
              }

              Navigator.of(context).pushNamed(taskGoToLocationStep2Route);
            }
                : null,
          ),
        );
      },
    );
  }

  Padding buildTable(Task task, BuildContext context) {
    final borderSide = BorderSide(color: Theme
        .of(context)
        .dividerTheme
        .color);
    final notes = task
        .notes; // ?? 'Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 18,
          ),
          Row(
            children: <Widget>[
              Text(
                '${DateFormat.jm().format(task.meta.startTime)} - ${DateFormat.jm().format(task.meta.endTime)}',
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
                  alignment: Alignment.center,
                  decoration: BoxDecoration(border: Border.all(color: Theme
                      .of(context)
                      .dividerTheme
                      .color)),
                  child: Padding(padding: EdgeInsets.all(9.0), child: Text(task.location.street)),
                ),
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(border: Border(right: borderSide, bottom: borderSide, top: borderSide)),
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 9.0, horizontal: 35.0),
                    child: Text(task.location.streetLine2)),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
//                            alignment: Alignment.center,
                  decoration: BoxDecoration(border: Border(left: borderSide, bottom: borderSide, right: borderSide)),
                  child: Padding(padding: EdgeInsets.all(9.0), child: Text('Notes')),
                ),
              ),
            ],
          ),
          notes != null
              ? Row(
            children: <Widget>[
              Expanded(
                child: Container(
//                            alignment: Alignment.center,
                  decoration:
                  BoxDecoration(border: Border(left: borderSide, bottom: borderSide, right: borderSide)),
                  child: Padding(
                      padding: EdgeInsets.all(9.0),
                      child: Text(
                        'Notes: $notes',
                        textAlign: TextAlign.justify,
                      )),
                ),
              ),
            ],
          )
              : Container()
        ],
      ),
    );
  }

//  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
//    if (_markerIcon == null) {
//      final ImageConfiguration imageConfiguration = createLocalImageConfiguration(context);
//      BitmapDescriptor.fromAssetImage(imageConfiguration, 'packages/map_launcher/assets/icons/osmand.png').then((BitmapDescriptor bitmap) {
//        setState(() {
//          _markerIcon = bitmap;
//        });
//      });
//    }
//  }

  Set<Marker> _createMarker(TaskLocation location) {
    return <Marker>[
      Marker(
        markerId: MarkerId("destination"),
        position: LatLng(location.lat, location.lng),
//        icon: _markerIcon,
      ),
    ].toSet();
  }
}
