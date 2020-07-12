import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:device_info/device_info.dart';
import 'package:bynextcourier/bloc/http_client_bloc.dart';
import 'package:bynextcourier/bloc/shift_details_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/model/rest_error.dart';
import 'package:bynextcourier/repository/sign_contract_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'sign_contract_event.dart';

part 'sign_contract_state.dart';

class SignContractBloc extends Bloc<SignContractEvent, SignContractState> {
  SignContractRepository repository;
  // ignore: close_sinks
  TokenBloc tokenBloc;
  // ignore: close_sinks
  ShiftDetailsBloc shiftDetailsBloc;
  // ignore: close_sinks
  HttpClientBloc httpClientBloc;

  @override
  SignContractState get initialState => SignContractReady();

  @override
  Stream<SignContractState> mapEventToState(SignContractEvent event) async* {
    if (event is StartUploadEvent) {
      if (state is SignContractReady) {
        yield SignContractProcessing();
        try {
          printLabel('StartUploadEvent', 'SignContractBloc');
          String imageUrl = await repository.performUploadFileWithImage(
              httpClientBloc.state.client, tokenBloc.state.token, event.imageData);
          printLabel('imageUrl: $imageUrl', 'SignContractBloc');
          if (imageUrl == null) {
            yield SignContractReady(error: {'error': 'imageUrl is null'});
          } else {
            final ShiftDetailsState state = shiftDetailsBloc.state;
            if (state is ShiftDetailsReady) {
              final shift = state.current;
              DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
              String deviceId;
              if (Platform.isIOS) {
                IosDeviceInfo info = await deviceInfo.iosInfo;
                deviceId = info.identifierForVendor;
              } else {
                AndroidDeviceInfo info = await deviceInfo.androidInfo;
                deviceId = info.androidId;
              }
              var result = await repository.performWithContractID(
                  httpClientBloc.state.client, tokenBloc.state.token, shift.contractId, imageUrl, deviceId);
              if (result != null) {
                yield SignContractDone();
              }
            } else {
              yield SignContractReady(error: {'error': 'shift is not initialized'});
            }
          }
        } catch (error) {
          if (error is RestError) {
            printLabel('errors:${error.errors}', 'SignContractBloc');
            yield SignContractReady(
              error: error.errors,
            );
          }
        }
      }
    }
  }
}
