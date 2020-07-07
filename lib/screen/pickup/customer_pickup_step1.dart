import 'package:bynextcourier/bloc/start_job/start_job_bloc.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/view/app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerPickupStep1 extends StatefulWidget {
  @override
  _CustomerPickupStep1State createState() => _CustomerPickupStep1State();
}

class _CustomerPickupStep1State extends State<CustomerPickupStep1> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartJobBloc, StartJobState>(
//      listener: (context, jobState) async {
//        if (jobState is ReadyToStartJobState &&
//          jobState.task?.meta?.firstOrder == true) {
//          await showCustomDialog2<void>(context, child: Container(
//            width: 60,
//            height: 60,
//            color: Colors.red,
//          ));
//        }
//      },
      builder: (context, jobState) {
        if (jobState is ReadyToStartJobState) {
          return Scaffold(
            appBar: AppBar(
//        title: AppBarTitle(
//        ),
                ),
            body: SafeArea(
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 14),
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
//                          child: Image.network(
//                            jobState.task.meta.userImage,
//                          ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon:
                              Image.asset("assets/images/heart-icon-fill.png"),
                        ),
                        Text(jobState?.task?.location?.name ?? ""),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Business Account'),
                        SizedBox(
                          width: 5,
                        ),
                        IconButton(
                          icon: Image.asset(
                            'assets/images/business.png',
//                                color: Colors.red,
                            color: Color(0xFF403D9C),
                          ),
                        ),
                      ],
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
                                child: IconButton(
                                    icon: Image.asset(
                                        "assets/images/navigation-icon.png")))
                          ],
                        ),
                        onPressed: jobState is ReadyToStartJobState &&
                                (jobState?.task?.location ?? null) != null
                            ? () {
//                        print("FFF");
                                launchMaps(context, jobState.task.location.lat,
                                    jobState.task.location.lng);
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
                            "View Building Photo",
                            textAlign: TextAlign.center,
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                  icon: Image.asset(
                                      "assets/images/bldg-image-yes.png"))),
                        ],
                      ),
                      onPressed: () {},
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).dividerTheme.color)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.all(9.0),
                                child: Text(jobState.task.location.street)),
                            Divider(),
                            Padding(padding: EdgeInsets.all(9.0), child: Text(
//                                jobState.task.
                                "8:00 PM – 9:00 PM")),
                            Divider(),
                            Padding(
                                padding: EdgeInsets.all(9.0),
                                child: Text("Pickup from Customer"
//                                startDate != null ? startDate : ''
                                    )),
                          ],
                        )),
                    Expanded(
                      child: Container(
                        height: 1,
                      ),
                    ),
                    RaisedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            "Arrived at place >>",
//                              textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      onPressed: () {},
                    )
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(
        seconds: 2,
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
    super.initState();
  }
}
