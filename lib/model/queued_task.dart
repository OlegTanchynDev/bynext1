class QueuedTask {
  final int status;
  final int id;
  final int type;
  final bool noShowEnabled;
  final int noShowWaitSeconds;
  final DateTime actionTime;

  final TaskContact contact;
  final TaskLocation location;
  final TaskMeta meta;

  final String notes;

  QueuedTask(
      {this.status,
      this.id,
      this.type,
      this.noShowEnabled,
      this.noShowWaitSeconds,
      this.actionTime,
      this.contact,
      this.location,
      this.meta,
      this.notes});

  factory QueuedTask.fromMap(Map<String, dynamic> map) {
    final task = map['task'];
    return QueuedTask(
        status: map['status'] as int,
        id: task['id'] as int,
        type: task['type'] as int,
        noShowEnabled: task['is_no_show_enabled'] as bool,
        noShowWaitSeconds: task['no_show_wait_seconds'] as int,
        actionTime: DateTime.parse(task['action_time'] as String),
        contact: TaskContact.fromMap(task['contact']),
        location: TaskLocation.fromMap(task['location']),
        meta: TaskMeta.fromMap(task['meta']),
        notes: task['notes'] as String);
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

  TaskMeta({
    this.firstOrder = false,
    this.wf,
    this.wp,
    this.dc,
    this.hd,
    this.express,
    this.userImage,
  });

  factory TaskMeta.fromMap(Map<String, dynamic> map) => TaskMeta(
        firstOrder: map['is_first_order'] as bool,
        wf: map['is_wf'] as bool,
        wp: map['is_wp'] as bool,
        dc: map['is_dc'] as bool,
        hd: map['is_hd'] as bool,
        express: map['is_express'] as bool,
        userImage: map['user_image'] as String,
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

//class TaskMeta {
//  final int id;
//  final String orderId;
//  final DateTime pickupDateTime;
//  final DateTime pickupDateTimeEnd;
//  final bool pickupEarly;
//
//
//}
