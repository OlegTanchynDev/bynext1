import 'package:flutter/material.dart';

class IssuesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Issues'),
        centerTitle: true,
        actions: <Widget>[const SizedBox(width: 50)],
      ),
    );
  }

}