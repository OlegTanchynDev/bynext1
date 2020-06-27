import 'package:background_locator/location_dto.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/repository/location_service_repository.dart';


class LocationCallbackHandler {
  static Future<void> initCallback(Map<dynamic, dynamic> params) async {
    LocationServiceRepository myLocationCallbackRepository =
    LocationServiceRepository();
    await myLocationCallbackRepository.init(params);
  }

  static Future<void> disposeCallback() async {
    LocationServiceRepository myLocationCallbackRepository =
    LocationServiceRepository();
    myLocationCallbackRepository.dispose();
  }

  static Future<void> callback(LocationDto locationDto) async {
    LocationServiceRepository myLocationCallbackRepository =
    LocationServiceRepository();
    myLocationCallbackRepository.callback(locationDto);
  }

  static Future<void> notificationCallback() async {
    printLabel('notificationCallback', null);
  }
}