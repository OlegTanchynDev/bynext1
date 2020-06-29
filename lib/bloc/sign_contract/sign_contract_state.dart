part of 'sign_contract_bloc.dart';

@immutable
abstract class SignContractState extends Equatable {
  @override
  List<Object> get props => [];
}


class SignContractReady extends SignContractState {
  final error;

  SignContractReady({this.error});
}
class SignContractProcessing extends SignContractState {}
class SignContractDone extends SignContractState {}