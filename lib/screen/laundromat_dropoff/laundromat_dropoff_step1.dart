import 'package:bynextcourier/bloc/task/task_bloc.dart';
import 'package:bynextcourier/view/arrived_button.dart';
import 'package:bynextcourier/view/task_map_view.dart';
import 'package:bynextcourier/view/task_notes_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LaundromatDropOffStep1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drop off to Dropshop'),
        centerTitle: true,
        actions: <Widget>[const SizedBox(width: 50)],
      ),
      body: SafeArea(
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (BuildContext context, state) {
            var task = (state as ReadyTaskState).task;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TaskMapView(),
                TaskNotesView(),
                Expanded(child: SizedBox()),
                ArrivedButton(),
              ],
            );
          },
        ),
      ),
    );
  }
}
