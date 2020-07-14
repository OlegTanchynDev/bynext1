import 'package:bynextcourier/bloc/driver_chat/driver_chat_bloc.dart';
import 'package:bynextcourier/view/app_bar_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverChatScreen extends StatefulWidget {
  DriverChatScreen({Key key}) : super(key: key);

  @override
  _DriverChatScreenState createState() => _DriverChatScreenState();
}

class _DriverChatScreenState extends State<DriverChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarLogo(),
        centerTitle: true,
        actions: <Widget>[const SizedBox(width: 50)],
      ),
      body: SafeArea(
        child: BlocBuilder<DriverChatBloc, DriverChatState>(
          builder: (BuildContext context, state) {
            return Container();
          },
        ),
      ),
    );
  }
}