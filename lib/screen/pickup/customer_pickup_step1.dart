import 'package:bynextcourier/bloc/task/task_bloc.dart';
import 'package:bynextcourier/helpers/task_utils.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/view/app_bar_title.dart';
import 'package:bynextcourier/view/arrived_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../../router.dart';

class CustomerPickupStep1 extends StatefulWidget {
  @override
  _CustomerPickupStep1State createState() => _CustomerPickupStep1State();
}

class _CustomerPickupStep1State extends State<CustomerPickupStep1> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, jobState) {
        if (jobState is ReadyTaskState) {
          return Scaffold(
            appBar: AppBar(title: AppBarTitle(task: jobState.task)),
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 14),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      child: Container(
                        width: 79,
                        height: 79,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                jobState.task.meta.userImage,
                              ),
                            )),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 5,
                      ),
                      child: Text.rich(customerName(jobState?.task)),
                    ),
                    Offstage(
                      offstage: !jobState.task.meta.isBusinessAccount,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Business Account'),
                          SizedBox(
                            width: 5,
                          ),
                          IconButton(
                            icon: Image.asset(
                              'assets/images/business.png',
                              color: Theme.of(context).buttonColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    RaisedButton(
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Text(
                              "Navigate to Location",
                              textAlign: TextAlign.center,
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(icon: Image.asset("assets/images/navigation-icon.png")))
                          ],
                        ),
                        onPressed: jobState is ReadyTaskState && (jobState?.task?.location ?? null) != null
                            ? () {
                                launchMaps(context, jobState.task.location.lat, jobState.task.location.lng);
                              }
                            : null),
                    SizedBox(
                      height: 7,
                    ),
                    RaisedButton(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Text(
                            jobState.task.meta?.buildingImgUrl != null ? "View Building Photo" : 'No Building Photo',
                            textAlign: TextAlign.center,
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(icon: Image.asset("assets/images/bldg-image-yes.png"))),
                        ],
                      ),
                      onPressed: jobState.task.meta?.buildingImgUrl != null ? () => Navigator.of(context)
                          .pushNamed(imageRoute, arguments: "$mediaUrl${jobState.task.meta.buildingImgUrl}") : null,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                        decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerTheme.color)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.all(9.0), child: Text(jobState.task.location.street)),
                            Divider(),
                            Padding(padding: EdgeInsets.all(9.0), child: Text(taskTimeInterval(jobState.task))),
                            Divider(),
                            Padding(padding: EdgeInsets.all(9.0), child: Text(taskShortDescription(jobState.task))),
                          ],
                        )),
                    Expanded(
                      child: Container(
                        height: 1,
                      ),
                    ),
                    ArrivedButton()
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: Text("No task selected"),
          );
        }
      },
    );
  }

  @override
  void initState() {
    final jobState = BlocProvider.of<TaskBloc>(context).state;
    if (jobState is ReadyTaskState && jobState.task.meta.firstOrder) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(Duration(
          milliseconds: 600,
        ));
        await showNoBarrierDialog(context,
            child: Column(
              children: <Widget>[
                IconButton(
                  icon: Image.asset(
                    "assets/images/heart-icon.png",
                    color: Colors.black,
                  ),
                ),
                Text("First time customer!"),
              ],
            )).timeout(Duration(seconds: 2), onTimeout: () {
          Navigator.of(context).pop();
        });
      });
    }

    super.initState();
  }
}
