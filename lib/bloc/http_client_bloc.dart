import 'package:bloc/bloc.dart';
import 'package:bynextcourier/client/app_http_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpClientBloc extends Bloc<HttpClientEvent, HttpClientState> {
  final BuildContext context;

  HttpClientBloc(this.context) : super(HttpClientState(http.Client(), false));

  @override
  Stream<HttpClientState> mapEventToState(HttpClientEvent event) async* {
    if (event is HttpClientDemo) {
      yield* _mapClientToState(event);
    } else if (event is HttpClientInitialize) {
      yield* _mapInitializeToState();
    } else if (event is HttpClientSetDemoTask) {
      yield* _mapSetDemoTaskToState(event);
    }
  }

  Stream<HttpClientState> _mapClientToState(HttpClientDemo event) async* {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('demo', event.useDemo);
    if (event.useDemo) {
      yield HttpClientState(DemoHttpClient(context), true);
    } else {
      yield HttpClientState(http.Client(), false);
    }
  }

  Stream<HttpClientState> _mapInitializeToState() async* {
    final prefs = await SharedPreferences.getInstance();
    final demo = prefs.getBool('demo') ?? false;
    add(HttpClientDemo(demo));
  }

  Stream<HttpClientState> _mapSetDemoTaskToState(HttpClientSetDemoTask event) async* {
    if (state.client is DemoHttpClient){
      yield HttpClientState(DemoHttpClient(context)..currentTask = event.newTask, true);
    }
  }
}

// Events
abstract class HttpClientEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class HttpClientInitialize extends HttpClientEvent {}

class HttpClientDemo extends HttpClientEvent {
  final bool useDemo;

  HttpClientDemo(this.useDemo);

  @override
  List<Object> get props => [useDemo];
}

class HttpClientSetDemoTask extends HttpClientEvent {
  final DemoTasks newTask;

  HttpClientSetDemoTask(this.newTask);

  @override
  List<Object> get props => [newTask];
}

// States
class HttpClientState extends Equatable {
  final Client client;
  final bool demo;

  HttpClientState(this.client, this.demo);

  @override
  List<Object> get props => [demo, client is DemoHttpClient ? (client as DemoHttpClient).currentTask : null];
}
