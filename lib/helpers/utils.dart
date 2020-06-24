import 'package:flutter/material.dart';

Future<Widget> showCustomDialog(BuildContext context, {String message, Widget button}) async{
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Align(
        child: Container(
          width: 250,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Center(
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
              ),
//              Divider(
//                height: 1.2,
//                thickness: 1.2,
//              ),
              Container(
                height: 1,
                color: Colors.grey,
              ),
              button,
//              SizedBox(
//                height: 5,
//              )
            ],
          ),
        ),
      );
    }
  );
}