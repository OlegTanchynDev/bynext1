import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  decoration: InputDecoration(hintText: 'Email', floatingLabelBehavior: FloatingLabelBehavior.never),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Password', floatingLabelBehavior: FloatingLabelBehavior.never),
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
                  onPressed: () {},
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