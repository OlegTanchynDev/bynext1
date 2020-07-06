import 'package:bynextcourier/bloc/start_job/start_job_bloc.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/view/app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerPickupStep1 extends StatelessWidget {

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
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20).copyWith(
                      bottom: 14),
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
                              )
                            ),
//                          child: Image.network(
//                            jobState.task.meta.userImage,
//                          ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(jobState?.task?.location?.name ?? ""),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Business Account'),
                            SizedBox(
                              width: 10,
                            ),
                            Image.asset('assets/images/business.png'),
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
                                child: IconButton(icon: Image.asset(
                                  "assets/images/navigation-icon.png"))
                              )
                            ],
                          ),
                          onPressed: jobState is ReadyToStartJobState && (jobState
                            ?.task?.location ?? null) != null ? () {
//                        print("FFF");
                            launchMaps(context, jobState.task.location.lat,
                              jobState.task.location.lng);
                          } : null
                        ),
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
                                child: IconButton(icon: Image.asset(
                                  "assets/images/navigation-icon.png"))
                              ),
                            ],
                          ),
                          onPressed: () {},
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          decoration:
                          BoxDecoration(border: Border.all(color: Theme.of(context).dividerTheme.color)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(padding: EdgeInsets.all(9.0), child: Text(jobState.task.location.street)),
                              Divider(),
                              Padding(
                                padding: EdgeInsets.all(9.0),
                                child: Text(
//                                jobState.task.
                                  "8:00 PM – 9:00 PM"
                                )
                              ),
                              Divider(),
                              Padding(
                                padding: EdgeInsets.all(9.0),
                                child: Text(
                                  "Pickup from Customer"
//                                startDate != null ? startDate : ''
                                )
                              ),
                            ],
                          )
                        ),

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
                          onPressed: (){},
                        )
                      ],
                    ),
                  ),
                  jobState is ReadyToStartJobState &&
                    jobState.task?.meta?.firstOrder == true ? Align(
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.green,
                    ),
                  ) : Container(),
                ],
              ),
            ),
          );
        }
        else{
          return Center(
            child: Text("No task selected"),
          );
        }
      },
    );
  }
}