import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:bynextcourier/bloc/barcode_details_bloc.dart';
import 'package:bynextcourier/bloc/http_client_bloc.dart';
import 'package:bynextcourier/bloc/location_tracker/location_tracker_bloc.dart';
import 'package:bynextcourier/bloc/maps_bloc.dart';
import 'package:bynextcourier/client/app_http_client.dart';
import 'package:bynextcourier/model/barcode_details.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:bynextcourier/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_is_emulator/flutter_is_emulator.dart';
import 'package:image_picker/image_picker.dart';
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

Future<T> showNoBarrierDialog<T>(BuildContext context,
  {Widget title, Widget child, bool noPadding = false, List<Widget> buttons}) async {
  return await showGeneralDialog<T>(
    transitionDuration: Duration(milliseconds: 150),
    barrierDismissible: false,
    barrierColor: null,
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return AlertDialog(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Theme.of(context).primaryColor,
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

Future<T> showContactsDialog<T>(BuildContext context, Task task, Timer timer) async {
  return await showCustomDialog2(context,
    noPadding: true,
    barrierDismissible: true,
    title: Text(
      'CONTACT CUSTOMER',
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    child: Column(
      children: <Widget>[
        buildDialogButton(
          Image.asset('assets/images/speech-bubble.png', color: Colors.black,),
          'MESSAGE', () {
          Navigator.of(context).pop();
          timer = new Timer(const Duration(milliseconds: 200), () async {
            var phoneNumber = task.contact.phone?.replaceAll(RegExp(r'[^\+\d]'), '');
            printLabel('press MESSAGE - tel:$phoneNumber ', 'TaskGoToLocationStep2Screen');
            if (await canLaunch('sms:')) {
              await launch('sms:$phoneNumber');
            }
          });
        }),
        buildDialogButton(
          Image.asset('assets/images/phone-call.png', color: Colors.black,),
          'CALL', () async {
          Navigator.of(context).pop();
          timer = new Timer(const Duration(milliseconds: 200), () async {
            var phoneNumber = task.contact.phone?.replaceAll(RegExp(r'[^\+\d]'), '');
            printLabel('press CALL - tel:$phoneNumber ', 'TaskGoToLocationStep2Screen');
            if (await canLaunch('tel:')) {
              await launch('tel:$phoneNumber');
            }
          });
        }),
        buildDialogButton(
          Image.asset('assets/images/phone-chat.png', color: Colors.black,),
          'CHAT', () {
          Navigator.of(context).pop();
          Navigator.of(context)
              .pushNamed(driverChatRoute, arguments: {'task': task});
        }),
      ],
    ),
    buttons: []
  );
}

InkWell buildDialogButton(Widget icon, String name, onTap) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Row(
        children: <Widget>[
          icon,
          SizedBox(
            width: 10.0,
          ),
          Expanded(child: Text(name)),
        ],
      ),
    ),
  );
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
  // ignore: close_sinks
  MapsBloc mapsBloc = BlocProvider.of<MapsBloc>(context);
  // ignore: close_sinks
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

List<String> getTaskCleaningOptions(Task task){
  final cleaningOptions = <String>[];
  if ((task.meta?.wf ?? false) && (task.meta?.hd ?? false)) {
    cleaningOptions.add('WF (+HD)');
  } else {
    if (task.meta?.wf ?? false) {
      cleaningOptions.add('WF');
    }
    if (task.meta?.hd ?? false) {
      cleaningOptions.add('HD');
    }
  }
  if (task.meta?.dc ?? false) {
    cleaningOptions.add('DC');
  }
  if (task.meta?.wp ?? false) {
    cleaningOptions.add('LS');
  }

  return cleaningOptions;
}

Future<ScanResult> scanBarCode(BuildContext context) async {
  if (context
    .bloc<HttpClientBloc>()
    .state
    .client is DemoHttpClient) {
//    final demoBarcode = BarcodeDetails(
//      status: 5,
//      id : 260,
//      type : 0,
//      barcode : "PU0000"
//    );
//    return demoBarcode;

    return ScanResult(
      type: ResultType.Barcode,
//      format: BarcodeFormat.
      rawContent: "PU0000"
    );
  }
  else {
    var result;
    try {
      result = await BarcodeScanner.scan();
      return result;
    } on PlatformException catch (e) {
      result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        result.rawContent = 'The user did not grant the camera permission!';
      } else {
        result.rawContent = 'Unknown error: $e';
      }
    }

    return result;
  }
}

Future getPhoto() async {
  final picker = ImagePicker();
  bool isIosEmulator = await isIosSimulator();
  final pickedFile = await picker.getImage(source: isIosEmulator ? ImageSource.gallery : ImageSource.camera);
  return pickedFile;
}