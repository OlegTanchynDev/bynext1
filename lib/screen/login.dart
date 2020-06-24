import 'package:bynextcourier/bloc/login_form_bloc.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 8.0),
        child: LayoutBuilder(builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraint.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 70,
                        child: Image(image: AssetImage('assets/images/logo.png')),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.center,
                      child: Image(
                        image: AssetImage('assets/images/logotype.png'),
                      ),
                    ),
                    const SizedBox(height: 14),
                    BlocListener(
                      bloc: BlocProvider.of<LoginFormBloc>(context),
                      listener: (context, state) async {
                        if (state is LoginFormReady && state.error != null && state.error['non_field_errors'] != null) {
                          await showCustomDialog(
                            context,
                            message: state.error['non_field_errors'],
                            button: FlatButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        }
                      },
                      child: BlocBuilder<LoginFormBloc, LoginFormState>(builder: (context, state) {
                        return Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                errorText:
                                    state is LoginFormReady && state.error != null ? state.error['username'] : null,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                errorText:
                                    state is LoginFormReady && state.error != null ? state.error['password'] : null,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        child: Text('Forgot your password?'),
                        onTap: () {
                          Navigator.of(context).pushNamed(forgotPasswordRoute);
                        },
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 0,
                      ),
                    ),
                    RaisedButton(
                      child: Text('LOGIN'),
                      onPressed: () => context
                          .bloc<LoginFormBloc>()
                          .submit(_usernameController.text.trim(), _passwordController.text),
                    ),
                    RaisedButton(
                      child: Text('DEMO MODE'),
                      onPressed: () => context.bloc<LoginFormBloc>().submit('demo', 'demo'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    ));
  }
}
