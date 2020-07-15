import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/http_client_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/model/barcode_details.dart';
import 'package:bynextcourier/repository/barcode_details_repository.dart';
import 'package:equatable/equatable.dart';

class BarcodeDetailsBloc extends Bloc<BarcodeDetailsBlocEvent, BarcodeDetailsBlocState> {
  BarcodeDetailsRepository repository;
  TokenBloc tokenBloc;
  HttpClientBloc httpClientBloc;

  StreamSubscription<TokenState> _tokenBlocSubscription;

  BarcodeDetailsBloc() : super(BarcodeDetailsBlocState(
    barcodes: [],
    notes: [],
  ));

  @override
  Stream<BarcodeDetailsBlocState> mapEventToState(BarcodeDetailsBlocEvent event) async* {
    if (event is GetBarcodeDetails) {
      var _barcodes = [];
      var _notes = [];
      try {
        _barcodes = await repository.fetchOrderAssignedBarcodes(httpClientBloc.state.client, tokenBloc.state.token, event.orderId);
//        yield BarcodeDetailsBlocState(barcodes: result);
      }
      catch (e){
//        yield BarcodeDetailsBlocState(
//          barcodes: [],
//        );
      }

      try {
        _notes = await repository.fetchOrderNotes(httpClientBloc.state.client, tokenBloc.state.token, event.orderId);
//        yield BarcodeDetailsBlocState(barcodes: result);
      }
      catch (e){
//        yield BarcodeDetailsBlocState(
//          barcodes: [],
//        );
      }
      
      yield BarcodeDetailsBlocState(
        barcodes: _barcodes,
        notes: _notes,
      );
    }
  }
}

// Events
abstract class BarcodeDetailsBlocEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetBarcodeDetails extends BarcodeDetailsBlocEvent {
  final String orderId;

  GetBarcodeDetails(this.orderId);
}

// States
class BarcodeDetailsBlocState extends Equatable {
  final List<BarcodeDetails> barcodes;
  final List<OrderNote> notes;

  BarcodeDetailsBlocState({this.notes, this.barcodes});

  @override
  List<Object> get props => [...barcodes, ...notes];
}
