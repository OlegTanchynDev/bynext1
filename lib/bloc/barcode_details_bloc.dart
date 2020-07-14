import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/http_client_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/model/barcode_details.dart';
import 'package:bynextcourier/repository/barcode_details_repository.dart';
import 'package:equatable/equatable.dart';

class BarcodeDetailsBloc extends Bloc<BarcodeDetailsBlocEvent, BarcodeDetailsBlocState> {
  BarcodeDetailsRepository repository;
  TokenBloc _tokenBloc;
  HttpClientBloc httpClientBloc;

  StreamSubscription<TokenState> _tokenBlocSubscription;

  BarcodeDetailsBloc() : super(BarcodeDetailsBlocState(
    barcodes: [],
  ));

  @override
  Stream<BarcodeDetailsBlocState> mapEventToState(BarcodeDetailsBlocEvent event) async* {
    if (event is GetBarcodes) {
      try {
        final result = await repository.fetchOrderAssignedBarcodes(httpClientBloc.state.client, _tokenBloc.state.token, event.taskId);
        yield BarcodeDetailsBlocState(barcodes: result);
      }
      catch (e){
        yield BarcodeDetailsBlocState();
      }
    }
  }
}

// Events
abstract class BarcodeDetailsBlocEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetBarcodes extends BarcodeDetailsBlocEvent {
  final int taskId;

  GetBarcodes(this.taskId);
}

// States
class BarcodeDetailsBlocState extends Equatable {
  final List<BarcodeDetails> barcodes;

  BarcodeDetailsBlocState({this.barcodes});

  @override
  List<Object> get props => [barcodes];
}
