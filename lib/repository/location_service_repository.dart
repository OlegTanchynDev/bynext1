import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:bynextcourier/constants.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/model/profile.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationServiceRepository {
  static LocationServiceRepository _instance = LocationServiceRepository._();

  LocationServiceRepository._();

  factory LocationServiceRepository() {
    return _instance;
  }

  static final num _keyDefaultTimeIntervalForMinimumLocationTracking = 10;
  static final num _keyDefaultTimeIntervalForLocationTransmit = 30;
  static final num _keyDefaultDistanceToleranceMeter = 10;

  static const String isolateName = 'LocatorIsolate';

  int _count = -1;
  List<LocationDto> myLocationArray = [];
  LocationDto myLastLocation;
  LocationDto myLastSentToServerLocation;
  Timer locationUpdateTimer;
  Timer minimumUserLocationTimer;

  Future<void> init(Map<dynamic, dynamic> params) async {
//    printLabel("Init callback handler", 'LocationServiceRepository');
    if (params.containsKey('countInit')) {
      dynamic tmpCount = params['countInit'];
      if (tmpCount is double) {
        _count = tmpCount.toInt();
      } else if (tmpCount is String) {
        _count = int.parse(tmpCount);
      } else if (tmpCount is int) {
        _count = tmpCount;
      } else {
        _count = -2;
      }
    } else {
      _count = 0;
    }

    myLocationArray = [];
//    printLabel("$_count", 'LocationServiceRepository');
//    printLabel("start", 'LocationServiceRepository');
    _startTracking();
    final SendPort send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  void dispose() {
//    printLabel("Dispose callback handler", 'LocationServiceRepository');
//    printLabel("$_count", 'LocationServiceRepository');
//    printLabel("end", 'LocationServiceRepository');
    final SendPort send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
    myLocationArray.clear();
    myLastSentToServerLocation = null;
    locationUpdateTimer?.cancel();
    minimumUserLocationTimer?.cancel();
  }

  void callback(LocationDto locationDto) {
//    printLabel('$_count location in dart: ${locationDto.toString()}', 'LocationServiceRepository');
    final SendPort send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(locationDto);
    _count++;
    myLastLocation = locationDto;
    myLocationArray.add(locationDto);
  }

  void _startTracking() async {
    final prefs = await SharedPreferences.getInstance();
    num timerInterval = prefs.getInt(Profile.keySendLocationIntervalSec) ?? _keyDefaultTimeIntervalForLocationTransmit;
//    printLabel('_startTracking, start locationUpdateTimer and minimumUserLocationTimer, timerInterval: $timerInterval',
//        'LocationServiceRepository');
    locationUpdateTimer = new Timer.periodic(Duration(seconds: timerInterval), _updateLocationToServer);
    _updateLocationToServer(locationUpdateTimer);
    minimumUserLocationTimer = new Timer.periodic(
        Duration(seconds: _keyDefaultTimeIntervalForMinimumLocationTracking), _checkIfUserArrivedAtDestinationLocation);
    _checkIfUserArrivedAtDestinationLocation(minimumUserLocationTimer);
  }

  void _updateLocationToServer(Timer timer) async {
//    printLabel('_updateLocationToServer', 'LocationServiceRepository');
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final token = prefs.getString('token');
//    printLabel('_updateLocationToServer token: $token', 'LocationServiceRepository');
    LocationDto myBestLocation;
    LocationDto myLocation;
    for (var i = 0; i < myLocationArray.length; i++) {
      LocationDto currentLoc = myLocationArray[i];
      if (i == 0) {
        myBestLocation = currentLoc;
      } else if (currentLoc.accuracy <= myBestLocation.accuracy) {
        myBestLocation = currentLoc;
      }
    }

    // If the array is 0, get the last location
    // Sometimes due to network issue or unknown reason, you could not get the location during that  period, the best you can do is sending the last known location to the server
    if (myLocationArray.length == 0) {
//      printLabel('myLocation=myLastLocation', 'LocationServiceRepository');
      myLocation = myLastLocation;
    } else {
//      printLabel('myLocation=myBestLocation', 'LocationServiceRepository');
      myLocation = myBestLocation;
    }

    if (myLocation == null) {
//      printLabel('myLocation is NULL, ignore sending', 'LocationServiceRepository');
      return;
    }
    // sending location to server
    bool locationChanged = true;
//    printLabel('locationChanged:$locationChanged', 'LocationServiceRepository');
    if (myLastSentToServerLocation != null) {
      final double meters = await Geolocator().distanceBetween(myLocation.latitude, myLocation.longitude,
          myLastSentToServerLocation.latitude, myLastSentToServerLocation.longitude);
      num distanceTolerance = prefs.getInt(Profile.keyDistanceToleranceMeter) ?? _keyDefaultDistanceToleranceMeter;
//      printLabel('profile distanceTolerance: $distanceTolerance, meters:$meters', 'LocationServiceRepository');
      if (meters < distanceTolerance) {
//        printLabel('meters < distanceTolerance, locationChanged:$locationChanged', 'LocationServiceRepository');
        locationChanged = false;
      }
      if (token != null && locationChanged) {
        //logged in
        _sendLocationToServer(myLocation, token);
      }
      // After sending the location to the server successful, remember to clear the current array with the following code.
      // It is to make sure that you clear up old location in the array and add the new locations from locationManager
      myLocationArray.clear();
    } else {
//      printLabel('myLastSentToServerLocation==NULL', 'LocationServiceRepository');
      if (token != null) {
        //logged in
        _sendLocationToServer(myLocation, token);
      }
    }
  }

  void _checkIfUserArrivedAtDestinationLocation(Timer timer) {}

  Future<void> _sendLocationToServer(LocationDto myLocation, String token) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
//    printLabel('_sendLocationToServer token:$token, myLocation:$myLocation, packageInfo.version:${packageInfo.version}',
//        'LocationServiceRepository');
    final response = await http.get(
      '$servicesUrl/delivery/v2/location/setCourierLocation/?lat=${myLocation.latitude}&long=${myLocation.longitude}&speed=${myLocation.speed}&accuracy=${myLocation.accuracy}&source=${packageInfo.version}',
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Token $token',
      },
    ).timeout(requestTimeout);

    if (response.statusCode == 200) {
//      printLabel('response string: ${response.body}', 'LocationServiceRepository');
      final parsed = json.decode(response.body);
//      printLabel('response: $parsed', 'LocationServiceRepository');
      myLastSentToServerLocation = myLocation;
    } else {
//      printLabel('error response string: ${response.body}', 'LocationServiceRepository');
    }
  }
}
