import 'package:bynextcourier/bloc/start_job/start_job_bloc.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/view/app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerPickupStep1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocListener<StartJobBloc, StartJobState>(
      listener: (context, jobState) {
        if (jobState is ReadyToStartJobState && jobState.task?.meta?.firstOrder == true) {
          //showNotificationDialog();
        }
      },
      child: Scaffold(
      appBar: AppBar(
//        title: AppBarTitle(
//        ),
      ),
      body: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 40,
          ),
          Text('John Doe'),
          Row(children: <Widget>[
            Text('Business Account'),
            Image.asset('assets/images/business.png'),
          ],)
        ],
      ),
      ),
    );
  }

}