import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_is_emulator/flutter_is_emulator.dart';
import 'package:bynextcourier/bloc/location_tracker/location_tracker_bloc.dart';
import 'package:bynextcourier/bloc/task/task_bloc.dart';
import 'package:bynextcourier/constants.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/model/task.dart';
import 'package:bynextcourier/view/app_bar_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskGoToLocationStep2Screen extends StatefulWidget {
  @override
  _TaskGoToLocationScreenState createState() => _TaskGoToLocationScreenState();
}

class _TaskGoToLocationScreenState extends State<TaskGoToLocationStep2Screen> {
  Timer _timer;
  File _image;
//  final picker = ImagePicker();

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var blocState = (BlocProvider.of<TaskBloc>(context).state as ReadyTaskState);
      if (blocState.task.meta.isEarly) {
        showNotesPopup(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarLogo(),
        centerTitle: true,
        actions: <Widget>[const SizedBox(width: 50)],
      ),
      body: SafeArea(
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (BuildContext context, state) {
            var task = (state as ReadyTaskState).task;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Stack(
                  overflow: Overflow.visible,
                  alignment: Alignment.bottomLeft,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: buildImgContainer(task, context),
                    ),
                    buildRow(task, context),
                  ],
                ),
                buildTable(task, context),
                Expanded(child: SizedBox()),
                buildButton(context, task),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildImgContainer(Task task, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    var buildingImgUrl = task.meta.buildingImgUrl != null ? '$mediaUrl${task.meta.buildingImgUrl}' : 'http://blank';
    return GestureDetector(
      onTap: task.meta.buildingImgUrl != null
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: AppBarLogo(),
                        centerTitle: true,
                      ),
                      body: Center(
                          child: Container(
                              width: screenWidth,
                              height: screenWidth,
                              color: Colors.grey[300],
                              child: buildImage(buildingImgUrl))),
                    );
                  },
                ),
              );
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
        ),
        height: 150,
        width: screenWidth,
        child: buildImage(buildingImgUrl),
      ),
    );
  }

  Image buildImage(String buildingImgUrl) {
    printLabel('buildImage _image: ${_image.toString()}', 'TaskGoToLocationStep2Screen');
    return _image != null
        ? Image.file(
            _image,
            fit: BoxFit.cover,
          )
        : Image.network(
            buildingImgUrl,
            fit: BoxFit.cover,
          );
  }

  Future<void> showNotesPopup(BuildContext context) async {
    return showCustomDialog<void>(context,
        title: 'Please Note',
        message:
            'You have arrived early to this task. Proceed to the next step only if the dispatcher approved. \n Proceeding without approval may result in grade reduction.',
        buttons: [
          IconButton(
            icon: ColorFiltered(
              colorFilter: const ColorFilter.mode(const Color(0xFF403D9C), BlendMode.srcIn),
              child: Image.asset('assets/images/checkbox-grey-checked.png'),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ]);
  }

  Row buildRow(Task task, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 0, left: 9),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(1),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/header-supplies.png'),
              radius: 36,
            ),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text('${task.meta?.jobTitle}'),
        )),
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 15, right: 12),
              child: InkWell(
                onTap: getImage,
                borderRadius: BorderRadius.circular(35),
                child: SizedBox(
                  height: 35,
                  width: 35,
                  child: Image.asset('assets/images/camera-btn.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                child: SizedBox(
                  height: 28,
                  width: 28,
                  child: InkWell(
                      borderRadius: BorderRadius.circular(28),
//                  splashColor: Colors.transparent,
//                  highlightColor: Colors.transparent,
//                  padding: EdgeInsets.all(0),
                      child: Image.asset(
                        'assets/images/call-icon.png',
                        color: Theme.of(context).colorScheme.secondaryVariant,
                      ),
                      onTap: () async {
                        //launchMaps(context, task.location.lat, task.location.lng);
                        var result = await showContactsDialog(context, task, _timer);

//                        var result = await showCustomDialog2(context,
//                            noPadding: true,
//                            barrierDismissible: true,
//                            title: Text(
//                              'CONTACT CUSTOMER',
//                              textAlign: TextAlign.center,
//                              style: TextStyle(fontWeight: FontWeight.bold),
//                            ),
//                            child: Column(
//                              children: <Widget>[
//                                buildDialogButton(
//                                    Image.asset('assets/images/speech-bubble.png', color: Colors.black,),
//                                    'MESSAGE', () {
//                                  Navigator.of(context).pop();
//                                  _timer = new Timer(const Duration(milliseconds: 200), () async {
//                                    var phoneNumber = task.contact.phone?.replaceAll(RegExp(r'[^\+\d]'), '');
//                                    printLabel('press MESSAGE - tel:$phoneNumber ', 'TaskGoToLocationStep2Screen');
//                                    if (await canLaunch('sms:')) {
//                                      await launch('sms:$phoneNumber');
//                                    }
//                                  });
//                                }),
//                                buildDialogButton(
//                                    Image.asset('assets/images/phone-call.png', color: Colors.black,),
//                                    'CALL', () async {
//                                  Navigator.of(context).pop();
//                                  _timer = new Timer(const Duration(milliseconds: 200), () async {
//                                    var phoneNumber = task.contact.phone?.replaceAll(RegExp(r'[^\+\d]'), '');
//                                    printLabel('press CALL - tel:$phoneNumber ', 'TaskGoToLocationStep2Screen');
//                                    if (await canLaunch('tel:')) {
//                                      await launch('tel:$phoneNumber');
//                                    }
//                                  });
//                                }),
//                                buildDialogButton(
//                                    Image.asset('assets/images/phone-chat.png', color: Colors.black,),
//                                    'CHAT', () {
//                                  Navigator.of(context).pop();
//                                  printLabel('press CHAT', 'TaskGoToLocationStep2Screen');
//                                }),
//                              ],
//                            ),
//                            buttons: []);
                      }
//                  iconSize: 28,
                      ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

//  InkWell buildDialogButton(Widget icon, String name, onTap) {
//    return InkWell(
//      onTap: onTap,
//      child: Padding(
//        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
//        child: Row(
//          children: <Widget>[
//            icon,
//            SizedBox(
//              width: 10.0,
//            ),
//            Expanded(child: Text(name)),
//          ],
//        ),
//      ),
//    );
//  }

  Future getImage() async {
//    bool isIosEmulator = await isIosSimulator();
//    final pickedFile = await picker.getImage(source: isIosEmulator ? ImageSource.gallery : ImageSource.camera);
    final pickedFile = await getPhoto();
    printLabel('getImage pickedFile.path: ${pickedFile?.path}', 'TaskGoToLocationStep2Screen');
    setState(() {
      _image = pickedFile?.path != null ? File(pickedFile?.path) : null;
    });
  }

  Widget buildButton(BuildContext context, Task task) {
    return BlocBuilder<LocationTrackerBloc, LocationTrackerBaseState>(
      builder: (BuildContext context, LocationTrackerBaseState state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
          child: RaisedButton(
            child: Text('PLEASE TAKE A PICTURE'),
            onPressed: getImage,
          ),
        );
      },
    );
  }

  Padding buildTable(Task task, BuildContext context) {
    final borderSide = BorderSide(color: Theme.of(context).dividerTheme.color);
    final notes = task
        .notes; // ?? 'Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 65),
                child: Text(
                  '${DateFormat.jm().format(task.actionTime)}',
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerTheme.color)),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                          width: 33,
                          height: 33,
                          child: Image.asset(
                            'assets/images/warning-icon.png',
//                            color: Theme.of(context).colorScheme.secondaryVariant,
                          )),
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.all(9.0),
                              child: Text(
                                task.location.name,
                                textAlign: TextAlign.center,
                              ))),
                      SizedBox(width: 33, height: 33, child: Image.asset('assets/images/warning-icon.png')),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(border: Border(left: borderSide, bottom: borderSide, right: borderSide)),
                  child: Padding(
                      padding: EdgeInsets.all(9.0),
                      child: Text(
                        notes ?? 'No notes',
                        textAlign: TextAlign.justify,
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
