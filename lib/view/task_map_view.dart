import 'package:bynextcourier/bloc/task/task_bloc.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TaskMapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, taskState) => Stack(
        overflow: Overflow.visible,
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Container(
              height: 150,
              child: GoogleMap(
                initialCameraPosition:
                CameraPosition(target: LatLng(taskState.task.location.lat, taskState.task.location.lng), zoom: 14.0),
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
//              onMapCreated: (GoogleMapController controller) {
//                setState(() {
//                  _controller = controller;
//                });
//              },
                markers: _createMarker(taskState.task.location),
              ),
            ),
          ),
          buildRow(taskState.task, context),
        ],
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