import 'package:bynextcourier/bloc/task/task_bloc.dart';
import 'package:bynextcourier/view/app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerDeliveryStep1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(task: BlocProvider.of<TaskBloc>(context).state.task),
      ),
    );
  }
}