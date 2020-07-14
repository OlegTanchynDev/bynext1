import 'package:bynextcourier/bloc/arrival_bloc.dart';
import 'package:bynextcourier/bloc/http_client_bloc.dart';
import 'package:bynextcourier/bloc/location_tracker/location_tracker_bloc.dart';
import 'package:bynextcourier/bloc/task/task_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:bynextcourier/repository/tasks_repository.dart';
import 'package:bynextcourier/router.dart';
import 'package:bynextcourier/view/animated_button.dart';
import 'package:bynextcourier/view/app_bar_logo.dart';
import 'package:bynextcourier/view/task_map_view.dart';
import 'package:bynextcourier/view/task_notes_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
                TaskMapView(),
                TaskNotesView(),
                Expanded(child: SizedBox()),
                buildButton(context, task),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, Task task) {
    return BlocBuilder<LocationTrackerBloc, LocationTrackerBaseState>(
      builder: (BuildContext context, LocationTrackerBaseState state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
          child: AnimatedButton(
            child: Text('Arrived at place >>'),
            condition: state.userArrivedAtDestinationLocation,
            onHorizontalDragUpdate: (details) {
              print('onHorizontalDragUpdate = ${details.primaryDelta}');
              if (details.primaryDelta > 40) {
                printLabel('onHorizontalDragUpdate', 'TaskGoToLocationScreen');
                context.bloc<ArrivalBloc>().add(ArrivedAtPlaceEvent());
              }
            }
          ),
        );
      },
    );
  }
}
