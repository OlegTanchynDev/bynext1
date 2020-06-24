import 'package:flutter/material.dart';

Future<Widget> showCustomDialog(BuildContext context, {String message, Widget button}) async {
  await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          contentPadding: EdgeInsets.all(0),
          buttonPadding: EdgeInsets.all(0),
          actionsPadding: EdgeInsets.all(0),
          insetPadding: EdgeInsets.symmetric(horizontal: 50),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const  EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                child: Text(
                  message ?? "",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(),
              button
            ],
          ),
        );
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  message ?? "",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
//              Divider(
//                height: 1.2,
//                thickness: 1.2,
//              ),
              Divider(),
              button,
//              SizedBox(
//                height: 5,
//              )
            ],
          ),
        );
      });
}
