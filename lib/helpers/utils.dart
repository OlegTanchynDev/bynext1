import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showCustomDialog(BuildContext context, {String message, Widget button}) async {
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
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
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
      });
}

callPhone(String phoneNumber) async {
  if (await canLaunch('tel://')) {
    await launch('tel://${phoneNumber.replaceAll(RegExp(r'[^\+\d]'), '')}');
//    '"(818) 999-8888"'
  }
}

launchMaps(double lat, double lon) async {
  String googleUrl = 'comgooglemaps://?center=$lat,$lon';
  String appleUrl = 'https://maps.apple.com/?sll=$lat,$lon';
  if (await canLaunch("comgooglemaps://")) {
    print('launching com googleUrl');
    await launch(googleUrl);
  } else if (await canLaunch(appleUrl)) {
    print('launching apple url');
    await launch(appleUrl);
  } else {
    throw 'Could not launch url';
  }
}

/*dp(locationDto.latitude, 4).toString()*/
double dp(double val, int places) {
  double mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}

String formatDateLog(DateTime date) {
  return date.hour.toString() + ":" + date.minute.toString() + ":" + date.second.toString();
}

void printLabel(String label, dynamic tag) {
  final date = DateTime.now();
  if (tag == null) {
    tag = '';
  } else {
    tag = '[$tag]';
  }
  print('$tag[${formatDateLog(date)}] $label');
}
