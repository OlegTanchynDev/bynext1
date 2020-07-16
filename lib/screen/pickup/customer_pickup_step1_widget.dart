import 'package:bynextcourier/constants.dart';
import 'package:bynextcourier/helpers/task_utils.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:bynextcourier/router.dart';
import 'package:bynextcourier/view/arrived_button.dart';
import 'package:flutter/material.dart';

class CustomerPickupStep1Widget extends StatefulWidget {
  final Task task;

  CustomerPickupStep1Widget({Key key, this.task}) : super(key: key);

  @override
  _CustomerPickupStep1WidgetState createState() => _CustomerPickupStep1WidgetState();
}

class _CustomerPickupStep1WidgetState extends State<CustomerPickupStep1Widget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                        widget.task.meta.userImage,
                      ),
                    )),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: 5,
              ),
              child: Text.rich(customerName(widget.task)),
            ),
            Offstage(
              offstage: !widget.task.meta.isBusinessAccount,
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
                onPressed: (widget.task?.location ?? null) != null
                    ? () {
                  launchMaps(context, widget.task.location.lat, widget.task.location.lng);
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
                    widget.task.meta?.buildingImgUrl != null ? "View Building Photo" : 'No Building Photo',
                    textAlign: TextAlign.center,
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(icon: Image.asset("assets/images/bldg-image-yes.png"))),
                ],
              ),
              onPressed: widget.task.meta?.buildingImgUrl != null ? () => Navigator.of(context, rootNavigator: true)
                  .pushNamed(imageRoute, arguments: "$mediaUrl${widget.task.meta.buildingImgUrl}") : null,
            ),
            SizedBox(
              height: 40,
            ),
            Container(
                decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerTheme.color)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(9.0), child: Text(widget.task.location.street)),
                    Divider(),
                    Padding(padding: EdgeInsets.all(9.0), child: Text(taskTimeInterval(widget.task))),
                    Divider(),
                    Padding(padding: EdgeInsets.all(9.0), child: Text(taskShortDescription(widget.task))),
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
    );
  }

  @override
  void initState() {
    if (widget.task.meta.firstOrder) {
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
          Navigator.of(context, rootNavigator: true).pop();
        });
      });
    }

    super.initState();
  }
}