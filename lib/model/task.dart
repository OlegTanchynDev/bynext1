enum CardType {
  COURIER_TASK_TYPE_GOTO_LOCATION,
  COURIER_TASK_TYPE_PICKUP_SUPPLIES,
  COURIER_TASK_TYPE_PICKUP_FROM_CLIENT,
  COURIER_TASK_TYPE_DELIVER_TO_CLIENT,
  COURIER_TASK_TYPE_LAUNDROMAT_PICKUP,
  COURIER_TASK_TYPE_LAUNDROMAT_DROPOFF
}

CardType parseCardTypeFromInt(int val) {
  switch (val) {
    case 0:
      return CardType.COURIER_TASK_TYPE_GOTO_LOCATION;
    case 1:
      return CardType.COURIER_TASK_TYPE_PICKUP_SUPPLIES;
    case 2:
      return CardType.COURIER_TASK_TYPE_PICKUP_FROM_CLIENT;
    case 3:
      return CardType.COURIER_TASK_TYPE_DELIVER_TO_CLIENT;
    case 4:
      return CardType.COURIER_TASK_TYPE_LAUNDROMAT_PICKUP;
    case 5:
      return CardType.COURIER_TASK_TYPE_LAUNDROMAT_DROPOFF;
    default:
      return null;
  }
}

class Task {
  final int id;
  final CardType type;
  final bool noShowEnabled;
  final int noShowWaitSeconds;
  final DateTime actionTime;

  final TaskContact contact;
  final TaskLocation location;
  final TaskMeta meta;

  final String notes;

  Task(
      {this.id,
      this.type,
      this.noShowEnabled,
      this.noShowWaitSeconds,
      this.actionTime,
      this.contact,
      this.location,
      this.meta,
      this.notes});

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        id: map['id'] as int,
        type: parseCardTypeFromInt(map['type'] as int),
        noShowEnabled: map['is_no_show_enabled'] as bool,
        noShowWaitSeconds: map['no_show_wait_seconds'] as int,
        actionTime: DateTime.parse(map['action_time'] as String),
        contact: TaskContact.fromMap(map['contact']),
        location: TaskLocation.fromMap(map['location']),
        meta: TaskMeta.fromMap(map['meta']),
        notes: map['notes'] as String);
  }

  @override
  String toString() {
    return 'Task{id: $id, type: $type, noShowEnabled: $noShowEnabled, noShowWaitSeconds: $noShowWaitSeconds, actionTime: $actionTime, notes: $notes}';
  }
}

class TaskMeta {
  final bool firstOrder;
  final bool wf;
  final bool wp;
  final bool dc;
  final bool hd;
  final bool express;
  final String userImage;

  //COURIER_TASK_TYPE_GOTO_LOCATION
  final DateTime startTime;
  final DateTime endTime;
  final String instructions;
  final bool isEarly;
  final int runType;
  final String jobTitle;
  final String buildingImgUrl;

  TaskMeta({
    this.firstOrder = false,
    this.wf,
    this.wp,
    this.dc,
    this.hd,
    this.express,
    this.userImage,
    this.startTime,
    this.endTime,
    this.instructions,
    this.isEarly = false,
    this.runType,
    this.jobTitle,
    this.buildingImgUrl,
  });

  factory TaskMeta.fromMap(Map<String, dynamic> map) => TaskMeta(
        firstOrder: map['is_first_order'] as bool,
        wf: map['is_wf'] as bool,
        wp: map['is_wp'] as bool,
        dc: map['is_dc'] as bool,
        hd: map['is_hd'] as bool,
        express: map['is_express'] as bool,
        userImage: map['user_image'] as String,

        //COURIER_TASK_TYPE_GOTO_LOCATION
        endTime: DateTime.tryParse(map['end_time'] as String ?? ''),
        startTime: DateTime.tryParse(map['start_time'] as String ?? ''),
        instructions: map['user_image'] as String,
        isEarly: map['is_early'] as bool,
        runType: map['run_type'] as int,
        jobTitle: map['job_title'] as String,
        buildingImgUrl: map['building_img_url'] as String,
      );
}

class TaskContact {
  final String name;
  final String phone;
  final String email;
  final String id;

  TaskContact({this.name, this.phone, this.email, this.id});

  factory TaskContact.fromMap(Map<String, dynamic> map) => TaskContact(
        id: map['id'] as String,
        name: map['name'] as String,
        email: map['email'] as String,
        phone: map['phone'] as String,
      );
}

class TaskLocation {
  final String name;
  final double lat;
  final double lng;
  final String notes;
  final String street;
  final String streetLine2;
  final String city;
  final String state;
  final String zipcode;
  final int floor;
  final bool doorman;
  final bool elevator;
  final bool latchBuilding;
  final bool doorCodeBuilding;

  TaskLocation(
      {this.name,
      this.lat,
      this.lng,
      this.notes,
      this.street,
      this.streetLine2,
      this.city,
      this.state,
      this.zipcode,
      this.floor,
      this.doorman,
      this.elevator,
      this.latchBuilding,
      this.doorCodeBuilding});

  factory TaskLocation.fromMap(Map<String, dynamic> map) {
    return TaskLocation(
      name: map['name'] as String,
      lat: map['lat'] as num,
      lng: map['lng'] as num,
      notes: map['notes'] as String,
      street: map['street_field1'] as String,
      streetLine2: map['street_field2'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      zipcode: map['zipcode'] as String,
    );
  }
}
