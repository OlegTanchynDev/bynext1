part of 'sign_contract_bloc.dart';

@immutable
abstract class SignContractEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class StartUploadEvent extends SignContractEvent{
  final Uint8List imageData;

  StartUploadEvent(this.imageData);

  @override
  List<Object> get props => [imageData];
}
