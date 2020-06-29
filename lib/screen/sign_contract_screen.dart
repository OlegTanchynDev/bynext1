import 'dart:convert';
import 'dart:typed_data';

import 'package:bynextcourier/bloc/profile_bloc.dart';
import 'package:bynextcourier/bloc/sign_contract/sign_contract_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/helpers/utils.dart';
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
    penColor: Color(0xFF403D9C),
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print("Value changed"));
  }

  List<Widget> actions(BuildContext context) {
    var declineButton = FlatButton(
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
      onPressed: () async {
//        Navigator.of(context).pop();
        if (_controller.isNotEmpty) {
          Uint8List data = await _controller.toPngBytes();
          context.bloc<SignContractBloc>().add(StartUploadEvent(data));
//          Navigator.of(context).push(
//            MaterialPageRoute(
//              builder: (BuildContext context) {
//                return Scaffold(
//                  appBar: AppBar(),
//                  body: Center(
//                      child: Container(
//                          color: Colors.grey[300], child: Image.memory(data))),
//                );
//              },
//            ),
//          );
        }
      },
    );
    return <Widget>[declineButton, Expanded(child: Center(child: title)), acceptButton];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignContractBloc, SignContractState>(
      listener: (BuildContext context, state) {
        if(state is SignContractDone){
          Navigator.of(context).pop();
        }
      },
      child: WillPopScope(
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
                          width: width * 0.85,
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }
}
