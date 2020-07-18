import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/http_client_bloc.dart';
import 'package:bynextcourier/bloc/task/task_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/model/barcode_details.dart';
import 'package:bynextcourier/model/rest_error.dart';
import 'package:bynextcourier/repository/barcode_details_repository.dart';
import 'package:equatable/equatable.dart';

class BarcodeDetailsBloc extends Bloc<BarcodeDetailsBlocEvent, BarcodeDetailsBlocState> {
  BarcodeDetailsRepository repository;
  TokenBloc tokenBloc;
  HttpClientBloc httpClientBloc;
  TaskBloc taskBloc;

  BarcodeDetailsBloc()
      : super(BarcodeDetailsBlocState(
          barcodes: [],
          notes: [],
        ));

  @override
  Stream<BarcodeDetailsBlocState> mapEventToState(BarcodeDetailsBlocEvent event) async* {
    if (event is GetBarcodeDetails) {
      var _barcodes = [];
      var _notes = [];
      try {
        _barcodes = await repository.fetchOrderAssignedBarcodes(
            httpClientBloc.state.client, tokenBloc.state.token, taskBloc.state.task.meta.orderId);
//        yield BarcodeDetailsBlocState(barcodes: result);
      } catch (e) {
//        yield BarcodeDetailsBlocState(
//          barcodes: [],
//        );
      }

      try {
        _notes = await repository.fetchOrderNotes(httpClientBloc.state.client, tokenBloc.state.token, taskBloc.state.task.meta.orderId);
//        yield BarcodeDetailsBlocState(barcodes: result);
      } catch (e) {
//        yield BarcodeDetailsBlocState(
//          barcodes: [],
//        );
      }

      yield BarcodeDetailsBlocState(
        barcodes: _barcodes,
        notes: _notes,
        error: null,
        newBarcode: event.newBarcode,
        newNote: event.newNote,
      );
    }

    if(event is AddBarcode) {
//      try {
        final success = await repository.addNewBarcode(
          httpClientBloc.state.client, tokenBloc.state.token, event.barcode,
          taskBloc.state.task
        );
        if (success) {
          add(GetBarcodeDetails(
            newBarcode: event.barcode,
          ));
        }
        else {
          yield BarcodeDetailsBlocState(
            barcodes: state.barcodes,
            notes: state.notes,
            error: RestError(
              errors: {
                "error" : "Pickup barcode is invalid"
              }
            ),
          );
        }
      }
//      catch (e) {
////        if (e is RestError) {
//          yield BarcodeDetailsBlocState(
//            barcodes: state.barcodes,
//            notes: state.notes,
//            error: e,
//          );
////        }
//      }
//    }

    if(event is RemoveBarcode) {
      final success = await repository.removeBarcode(httpClientBloc.state.client, tokenBloc.state.token, event.barcode.barcode, taskBloc.state.task);
      if(success) {
        add(GetBarcodeDetails());
      }
    }

    if(event is AddNote) {
      final success = await repository.addNewOrderNote(
        httpClientBloc.state.client, tokenBloc.state.token, event.note,
        taskBloc.state.task.meta.orderId
      );
      if (success) {
        add(GetBarcodeDetails(
          newNote: event.note.text,
        ));
      }
      else {
        yield BarcodeDetailsBlocState(
          barcodes: state.barcodes,
          notes: state.notes,
          error: RestError(
            errors: {
              "error" : "Pickup barcode is invalid"
            }
          ),
        );
      }
    }
  }
}

// Events
abstract class BarcodeDetailsBlocEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetBarcodeDetails extends BarcodeDetailsBlocEvent {
  final String newBarcode;
  final String newNote;

  GetBarcodeDetails({this.newBarcode, this.newNote});
}

class RemoveBarcode extends BarcodeDetailsBlocEvent {
//  final String barcode;
  final BarcodeDetails barcode;

  RemoveBarcode(this.barcode);
}

class AddBarcode extends BarcodeDetailsBlocEvent {
  final String barcode;
//  final Task task;

  AddBarcode(this.barcode);
}

class AddNote extends BarcodeDetailsBlocEvent {
  final OrderNote note;

  AddNote(this.note);
}


// States
class BarcodeDetailsBlocState extends Equatable {
  final List<BarcodeDetails> barcodes;
  final List<OrderNote> notes;
  final RestError error;
  final String newBarcode;
  final String newNote;

  BarcodeDetailsBlocState({this.notes, this.barcodes, this.error, this.newBarcode, this.newNote});

  @override
  List<Object> get props => [...barcodes, ...notes, error];
}
