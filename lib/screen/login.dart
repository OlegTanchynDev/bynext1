import 'package:bynextcourier/bloc/LoginFormBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String username;
    String password;

    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Image(image: AssetImage('assets/images/logo.png')),
                ),
                const SizedBox(height: 14),
                Align(alignment: Alignment.center, child: Image(image: AssetImage('assets/images/logotype.png'))),
                const SizedBox(height: 14),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    floatingLabelBehavior: FloatingLabelBehavior.never
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) => username = val,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Password', floatingLabelBehavior: FloatingLabelBehavior.never),
                  onChanged: (val) => password = val,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    child: Text('Forgot your password?'),
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 0,
                  ),
                ),
                RaisedButton(
                  child: Text('LOGIN'),
                  onPressed: () => context.bloc<LoginFormBloc>().submit(username, password),
                ),
                RaisedButton(
                  child: Text('DEMO MODE'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ));
  }
}