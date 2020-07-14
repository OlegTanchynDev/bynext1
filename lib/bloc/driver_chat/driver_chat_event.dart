part of 'driver_chat_bloc.dart';

@immutable
abstract class DriverChatEvent  extends Equatable {
  @override
  List<Object> get props => [];
}

class GetFirebaseAuthEvent extends DriverChatEvent {
  final num taskId;

  GetFirebaseAuthEvent(this.taskId);

  @override
  List<Object> get props => [taskId];
}
