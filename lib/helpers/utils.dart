import 'dart:io';
import 'dart:math';

import 'package:bynextcourier/bloc/location_tracker/location_tracker_bloc.dart';
import 'package:bynextcourier/bloc/maps_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_is_emulator/flutter_is_emulator.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

Future<dynamic> showCustomDialog<T>(BuildContext context, {String title, String message, List<Widget> buttons}) async {
  return await showDialog<T>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          contentPadding: EdgeInsets.all(0),
          buttonPadding: EdgeInsets.all(0),
          actionsPadding: EdgeInsets.all(0),
          insetPadding: EdgeInsets.symmetric(horizontal: 50),
          title: title != null ? Text(title, textAlign: TextAlign.center) : null,
          titleTextStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            color: Colors.black,
            decoration: TextDecoration.none,
          ),
          content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                      child: Text(
                        message ?? "",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ] +
                  ((buttons?.length ?? 0) > 0
                      ? [
                          Divider(),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: buttons
                                .expand<Widget>((item) => [
                                      Expanded(child: item),
                                      Container(
                                          width: 0.5,
                                          height: Theme.of(context).buttonTheme.height + 7,
                                          color: Theme.of(context).dividerTheme.color)
                                    ])
                                .toList(),
                          ),
                        ]
                      : [])),
        );
      });
}

Future<T> showCustomDialog2<T>(BuildContext context,
    {Widget title, Widget child, bool noPadding = false, bool barrierDismissible = false, List<Widget> buttons}) async {
  return await showDialog<T>(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          contentPadding: EdgeInsets.all(0),
          buttonPadding: EdgeInsets.all(0),
          actionsPadding: EdgeInsets.all(0),
          insetPadding: EdgeInsets.symmetric(horizontal: 50),
          title: title,
          titleTextStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            color: Colors.black,
            decoration: TextDecoration.none,
          ),
          content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: noPadding ? 4 : 30, vertical: 16),
                      child: DefaultTextStyle(
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                          child: child),
                    ),
                  ] +
                  ((buttons?.length ?? 0) > 0
                      ? [
                          Divider(),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: buttons
                                .expand<Widget>((item) => [
                                      Expanded(child: item),
                                      Container(
                                          width: 0.5,
                                          height: Theme.of(context).buttonTheme.height + 7,
                                          color: Theme.of(context).dividerTheme.color)
                                    ])
                                .toList(),
                          ),
                        ]
                      : [])),
        );
      });
}

callPhone(BuildContext context, String phoneNumber, String name) async {
  if (await canLaunch('tel:')) {
    if (await showCustomDialog<bool>(context, title: 'Call Dispatcher', message: 'Call $name', buttons: [
          FlatButton(
            child: Text('Confirm'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          FlatButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          )
        ]) ??
        false) {
      await launch('tel:${phoneNumber.replaceAll(RegExp(r'[^\+\d]'), '')}');
    }
  }
}

launchMaps(BuildContext context, double lat, double lon) async {
  MapsBloc mapsBloc = BlocProvider.of<MapsBloc>(context);
  LocationTrackerBloc trackerBloc = BlocProvider.of<LocationTrackerBloc>(context);
  var map = mapsBloc.state.enabled;
  var myLocation = trackerBloc.state.location;

  List<AvailableMap> available = await MapLauncher.installedMaps;
  AvailableMap availableMap = available.firstWhere((element) => element.mapName == map);
  if (availableMap.mapType == MapType.apple) {
//    String appleUrl = 'http://maps.apple.com/maps?daddr=$lat,$lon&dirflg=c';
//    if (myLocation != null) {
//      appleUrl += '&saddr=${myLocation.latitude},${myLocation.longitude}';
//    }
//    print('launching apple url:$appleUrl');
//    await launch(appleUrl);
    await MapLauncher.launchMap(
      mapType: MapType.apple,
      coords: Coords(lat, lon),
      title: 'Destination',
      description: 'Destination',
    );
  } else if (availableMap.mapType == MapType.google) {
//    String googleUrl = 'https://maps.google.com/?daddr=$lat,$lon&directionsmode=driving';
//    if (myLocation != null) {
//      googleUrl += '&saddr=${myLocation.latitude},${myLocation.longitude}';
//    }
//    print('launching com googleUrl:$googleUrl');
//    await launch(googleUrl);
    MapLauncher.launchMap(
      mapType: MapType.google,
      coords: Coords(lat, lon),
      title: 'Destination',
      description: 'Destination',
    );
  } else if (availableMap.mapType == MapType.waze) {
    print('launching waze url');
    await MapLauncher.launchMap(
      mapType: MapType.waze,
      coords: Coords(lat, lon),
      title: 'Destination',
      description: 'Destination',
    );
  }
//  String googleUrl = 'comgooglemaps://?center=$lat,$lon';
//  String appleUrl = 'https://maps.apple.com/?sll=$lat,$lon';
//  if (await canLaunch("comgooglemaps://")) {
//    print('launching com googleUrl');
//    await launch(googleUrl);
//  } else if (await canLaunch(appleUrl)) {
//    print('launching apple url');
//
//    await launch(appleUrl);
//  } else {
//    throw 'Could not launch url';
//  }
}

/*dp(locationDto.latitude, 4).toString()*/
double dp(double val, int places) {
  double mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}

String formatDateLog(DateTime date) {
  return date.hour.toString() + ":" + date.minute.toString() + ":" + date.second.toString();
}

void printLabel(String label, dynamic tag) {
  final date = DateTime.now();
  if (tag == null) {
    tag = '';
  } else {
    tag = '[$tag]';
  }
  print('$tag[${formatDateLog(date)}] $label');
}

Future<bool> isIosSimulator() async {
  bool isAnEmulator = await FlutterIsEmulator.isDeviceAnEmulatorOrASimulator;
  return isAnEmulator && Platform.isIOS;
}