import 'package:bynextcourier/model/task.dart';

class QueuedTask {
  final int status;
  final Task task;

  QueuedTask({this.status,
    this.task,
  });

  factory QueuedTask.fromMap(Map<String, dynamic> map) {
    return QueuedTask(
      status: map['status'] as int,
      task: Task.fromMap(map['task']),
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
