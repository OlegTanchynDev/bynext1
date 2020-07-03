import 'package:bynextcourier/bloc/start_job/start_job_bloc.dart';
import 'package:bynextcourier/model/task.dart';
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
        title: Text('Go to location'),
        centerTitle: true,
        actions: <Widget>[const SizedBox(width: 50)],
      ),
      body: BlocBuilder<StartJobBloc, StartJobState>(
        builder: (BuildContext context, state) {
          var task = (state as ReadyToStartJobState).task;
          return Column(
            children: <Widget>[
              Container(
                height: 150,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(task.location.lat, task.location.lng), zoom: 14.0),
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
              Row(children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(1),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/header-supplies.png'),
                    radius: 26,
                  ),
                )

              ],),
            ],
          );
        },
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
