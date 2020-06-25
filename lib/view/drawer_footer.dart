import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class DrawerFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline6,
      child: FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Text('Version: ${snapshot.data.version}');
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
