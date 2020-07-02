import 'package:bynextcourier/client/app_http_client.dart';

class DemoResponse {
  final String _assetPath;

  String assetPath(DemoTasks demoTask) => _assetPath;

  DemoResponse(this._assetPath);
}

class DemoTaskResponse extends DemoResponse {
  DemoTaskResponse() : super(null);

  @override
  String assetPath(DemoTasks demoTask) {
    String jsonName = "";
    switch (demoTask) {
      case DemoTasks.pickupFromClient:
      case DemoTasks.pickupFromClientPu:
        jsonName = "tasks_getTask_customer_pickup";
        break;
      case DemoTasks.laundromatPickup:
      case DemoTasks.laundromatPickupPu:
        jsonName = "tasks_getTask_warehouse_pickup";
        break;
      case DemoTasks.laundromatDropoff:
      case DemoTasks.laundromatDropoffPu:
        jsonName = "tasks_getTask_warehouse_drop_off";
        break;
      case DemoTasks.gotoLocation:
        jsonName = "tasks_getTask_manual";
        break;
      case DemoTasks.batched:
        jsonName = "tasks_getTask_batched";
        break;
//      case DemoTasks.deliverToClient:
//        jsonName = "missed";
//        break;
    }

    return "assets/mock/regular-business/$jsonName.json";
  }
}
