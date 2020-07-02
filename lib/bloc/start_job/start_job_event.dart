part of 'start_job_bloc.dart';

@immutable
abstract class StartJobEvent  extends Equatable {
  @override
  List<Object> get props => [];
}

class GetNextTaskEvent extends StartJobEvent{
  final int shiftId;
  final bool business;

  GetNextTaskEvent(this.shiftId, this.business);

  @override
  List<Object> get props => [shiftId, business];
}
