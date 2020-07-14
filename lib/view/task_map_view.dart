import 'package:bynextcourier/bloc/task/task_bloc.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class TaskMapView extends StatelessWidget {
  final bool showTime;

  const TaskMapView({Key key, this.showTime = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, taskState) {
        final task = taskState.task;
        return Stack(
          overflow: Overflow.visible,
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Container(
                height: 150,
                child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: LatLng(task.location.lat, task.location.lng), zoom: 14.0),
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
//              onMapCreated: (GoogleMapController controller) {
//                setState(() {
//                  _controller = controller;
//                });
//              },
                  markers: _createMarker(task.location),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 4),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(1),
                child: CircleAvatar(
                  backgroundImage: AssetImage(cardTypeImageAsset(task.type)),
                  radius: 36,
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(bottom: 28, right: 18),
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
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 90,
                ),
                Expanded(child: Text(task.location.name)),
                showTime ? Text(DateFormat.jm().format(task.actionTime)) : Container(),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
          ],
        );
      },
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
