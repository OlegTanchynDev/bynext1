import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/location_settings.dart';
import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/location_tracker/location_callback_handler.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/repository/location_service_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:meta/meta.dart';

part 'location_tracker_event.dart';

part 'location_tracker_state.dart';

class LocationTrackerBloc extends Bloc<LocationTrackerEvent, LocationTrackerBaseState> {
  @override
  InitialLocationTrackerState get initialState => InitialLocationTrackerState();

//  StreamSubscription<Position> _positionStreamSubscription;
  ReceivePort port = ReceivePort();
  bool isServiceRunning = false;
  LocationDto lastLocation;
  bool userArrivedAtDestinationLocation = false;

  void startLocationTracking() {
    printLabel('startLocationTracking', 'LocationTrackerBloc');
    add(StartLocationTrackingEvent());
  }

  void stopLocationTracking() {
    printLabel('stopLocationTracking', 'LocationTrackerBloc');
    add(StopLocationTrackingEvent());
  }

  void initAndStartLocationTrackingIfNeeded() async {
    printLabel('initAndStartLocationTracking', 'LocationTrackerBloc');
    add(InitAndStartLocationTrackingEvent());
  }

  Future<bool> _checkLocationPermission() async {
    final access = await LocationPermissions().checkPermissionStatus();
    switch (access) {
      case PermissionStatus.unknown:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        final permission = await LocationPermissions().requestPermissions(
          permissionLevel: LocationPermissionLevel.locationAlways,
        );
        if (permission == PermissionStatus.granted) {
          return true;
        } else {
          return false;
        }
        break;
      case PermissionStatus.granted:
        return true;
        break;
      default:
        return false;
        break;
    }
  }

  void _onUpdateLocation(params) {
    lastLocation = params['location'];
    userArrivedAtDestinationLocation = params['userArrivedAtDestinationLocation'];
    print('_onUpdateLocation\n userArrivedAtDestinationLocation:$userArrivedAtDestinationLocation\n location:' +
        lastLocation.toString());
    add(OnUpdateLocationEvent(lastLocation, userArrivedAtDestinationLocation));
  }

  @override
  Stream<LocationTrackerState> mapEventToState(LocationTrackerEvent event) async* {
    if (event is InitAndStartLocationTrackingEvent) {
      yield* _initAndStartLocationTracking();
    } else if (event is OnUpdateLocationEvent) {
      yield LocationTrackerState(isServiceRunning, event.location, event.userArrivedAtDestinationLocation);
    } else if (event is StopLocationTrackingEvent) {
      isServiceRunning = false;
      BackgroundLocator.unRegisterLocationUpdate();
      yield LocationTrackerState(isServiceRunning, null, false);
    }
  }

  @override
  Future<void> close() {
    printLabel('LocationTrackerBloc close', 'LocationTrackerBloc');
    return super.close();
  }

  Stream<LocationTrackerState> _initAndStartLocationTracking() async* {
    if (IsolateNameServer.lookupPortByName(LocationServiceRepository.isolateName) != null) {
      IsolateNameServer.removePortNameMapping(LocationServiceRepository.isolateName);
    }
    IsolateNameServer.registerPortWithName(port.sendPort, LocationServiceRepository.isolateName);
    port.listen(
      _onUpdateLocation,
    );

    printLabel('Initializing...', 'LocationTrackerBloc');
    await BackgroundLocator.initialize();
    printLabel('Initialization done', 'LocationTrackerBloc');
    isServiceRunning = await BackgroundLocator.isRegisterLocationUpdate();
    printLabel(
        'Running $isServiceRunning, lastLocation:$lastLocation,  userArrivedAtDestinationLocation:$userArrivedAtDestinationLocation',
        'LocationTrackerBloc');
    if (isServiceRunning) {
      await BackgroundLocator.unRegisterLocationUpdate();
      yield LocationTrackerState(isServiceRunning, lastLocation, userArrivedAtDestinationLocation);
    }
    _startLocator();
  }

  void _startLocator() async {
    if (await _checkLocationPermission()) {
      printLabel('_startLocator', 'LocationTrackerBloc');
      Map<String, dynamic> data = {'countInit': 1};
      BackgroundLocator.registerLocationUpdate(
        LocationCallbackHandler.callback,
        initCallback: LocationCallbackHandler.initCallback,
        initDataCallback: data,
        disposeCallback: LocationCallbackHandler.disposeCallback,
        androidNotificationCallback: LocationCallbackHandler.notificationCallback,
        settings: LocationSettings(
            notificationChannelName: "Location tracking service",
            notificationTitle: "Start Location Tracking",
            notificationMsg: "Track location",
            wakeLockTime: 20,
            autoStop: false,
            interval: 5),
      );
      isServiceRunning = true;
    }
  }
}
