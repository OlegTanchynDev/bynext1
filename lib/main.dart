import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.grey,
          scaffoldBackgroundColor: Color(0xFFF2EDEB),


          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF232456),
            primaryVariant: Color(0xFF4a4a4a),
            secondary: Color(0xFF232456),
            // <-- text color
            secondaryVariant: Color(0xFF848484),
            surface: Color(0xFF232456),
            background: Color(0xFFF2EDEB),
            error: Colors.red,
            onPrimary:  Color(0xFFF2EDEB),
            onSecondary: Color(0xFFF2EDEB),
            onBackground: Color(0xFF232456),
            onError: Color(0xFFFFDDDD),
            onSurface: Color(0xFF232456), // <-- disabled text color, INPUT DECORATION
          ),


          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
            // edit text
            subtitle1: TextStyle(
              fontFamily: 'Avenir',
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),

            bodyText2: TextStyle(
              fontFamily: 'Avenir',
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Color(0xFF232456)
            ),
            //buttons
            button: TextStyle(
              fontFamily: 'Avenir',
              fontSize: 18,
              fontWeight: FontWeight.w300,
            )
          ),

          buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
            height: 41,
            buttonColor: Color(0xFF403D9C),
          ),
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(0.0))),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          )),
      home: GestureDetector(onTap: () => FocusScope.of(context).requestFocus(new FocusNode()), child: LoginPage()),
    );
  }
}

class LoginPage extends StatelessWidget {
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
