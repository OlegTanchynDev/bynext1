import 'dart:convert';

import 'package:bynextcourier/bloc/profile_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/view/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signature/signature.dart';

class SignContractScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignContractScreenState();
}

class _SignContractScreenState extends State<SignContractScreen> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.blue,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print("Value changed"));
  }

  List<Widget> actions(BuildContext context) {
    var declineButton = FlatButton(
//      shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
      child: Text('Cancel'),
      onPressed: () async {
        await showCustomDialog(
          context,
          title: 'Contract declined',
          message: 'You must accept your contract inorder to begin you shift. You will now be logged out.',
          buttons: [
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
        Navigator.of(context).pop();
        BlocProvider.of<TokenBloc>(context).add(ClearToken());
      },
    );
    var title = Text('Sign Contract');
    var acceptButton = FlatButton(
      child: Text('Submit'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    return <Widget>[declineButton, Expanded(child: Center(child: title)), acceptButton];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
            title: null,
            automaticallyImplyLeading: false,
            actions: actions(context),
          ),
          body: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (BuildContext context, ProfileState state) {
              double width = MediaQuery.of(context).size.width;
              return Center(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 50),
                    Text(
                      'I, ${state.profile.firstName} ${state.profile.lastName}, agree to the Terms of the Contract\n\n(Sign below)',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    Container(
                      height: 200,
                      width: width * 0.85,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Colors.black),
                      ),
                      child: Signature(
                        controller: _controller,
                        height: 200,
                        width: width * 0.75,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
