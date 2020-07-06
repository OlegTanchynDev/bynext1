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
        return Scaffold(
          appBar: AppBar(
//        title: AppBarTitle(
//        ),
          ),
          body: Stack(
            children: <Widget>[
              jobState is ReadyToStartJobState &&
                jobState.task?.meta?.firstOrder == true ? Align(
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.green,
                ),
              ) : Container(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 14),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                    ),
                    Text('John Le'),
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
                            child: IconButton(icon :Image.asset("assets/images/navigation-icon.png"))
                          )
                        ],
                      ),
                      onPressed: jobState is ReadyToStartJobState && (jobState?.task?.location ?? null) != null ?() {
//                        print("FFF");
                        launchMaps(context, jobState.task.location.lat, jobState.task.location.lng);
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
                            child: IconButton(icon :Image.asset("assets/images/navigation-icon.png"))
                          ),
                        ],
                      ),
                      onPressed: (){},
                    ),
                    SizedBox(
                      height: 40,
                    ),

                    Row(
                      children: <Widget>[
                        Text('Business Account'),
                        Image.asset('assets/images/business.png'),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}