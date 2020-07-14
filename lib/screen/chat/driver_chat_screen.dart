import 'package:bynextcourier/bloc/driver_chat/driver_chat_bloc.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:bynextcourier/view/app_bar_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';

class DriverChatScreen extends StatefulWidget {
  final Task task;

  DriverChatScreen({Key key, this.task}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      this.settingData();
    });

  }

  void settingData() {
    var taskId = widget.task.id;
    var contactId = widget.task.contact.id;
    printLabel('settingData taskId:$taskId, contactId:$contactId', 'DriverChatScreen');
    Provider.of<DriverChatBloc>(context, listen: false).add(GetFirebaseAuthEvent(taskId));
  }
}