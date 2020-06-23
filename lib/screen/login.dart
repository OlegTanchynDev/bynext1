import 'package:bynextcourier/bloc/login_form_bloc.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/router.dart';
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
          child: LayoutBuilder(
            builder: (context, constraint) {
              print(constraint);
              print(MediaQuery
                .of(context)
                .viewInsets);
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
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 70,
                            child: Image(
                              image: AssetImage('assets/images/logo.png')
                            ),
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
                            if (state is LoginFormReady && state.error != null && state.error['non_field_errors'] != null){
                              await showCustomDialog(
                                context,
                                message: state.error['non_field_errors'],
                                button: RaisedButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              );

//                              await showDialog(
//                                context: context,
//                                builder: (context) {
//                                  return Align(
//                                    child: Container(
//                                      width: 250,
//                                      height: 150,
//                                      decoration: BoxDecoration(
//                                        color: Colors.white,
//                                        borderRadius: BorderRadius.circular(5),
//                                      ),
//                                      child: Column(
//                                        children: <Widget>[
//                                          Expanded(
//                                            child: Center(
//                                              child: Text(
//                                                state.error['non_field_errors'],
//                                                style: TextStyle(
//                                                  fontSize: 17,
//                                                  fontWeight: FontWeight.normal,
//                                                  fontStyle: FontStyle.normal,
//                                                  color: Colors.black,
//                                                  decoration: TextDecoration.none,
//                                                ),
//                                                textAlign: TextAlign.center,
//                                              ),
//                                            ),
//                                          ),
//                                          RaisedButton(
//                                            child: Text('OK'),
//                                            onPressed: () {
//                                              Navigator.of(context).pop();
//                                            },
//                                          ),
//                                          SizedBox(
//                                            height: 5,
//                                          )
//                                        ],
//                                      ),
//                                    ),
//                                  );
//                                }
//                              );
                            }
                          },
                          child: BlocBuilder(
                            bloc: BlocProvider.of<LoginFormBloc>(context),
                            builder: (context, state) {
                              return Column(
                                children: <Widget>[
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      errorText:  state is LoginFormReady && state.error != null ? state.error['username'] : null,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (val) => username = val,
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(hintText: 'Password',
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      errorText:  state is LoginFormReady && state.error != null ? state.error['password'] : null,
                                    ),
                                    onChanged: (val) => password = val,
                                  ),
                                ],
                              );
                            }
                          ),
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
                          onPressed: () =>
                            context.bloc<LoginFormBloc>().submit(
                              username, password),
                        ),
                        RaisedButton(
                          child: Text('DEMO MODE'),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          ),
        ),
      )
    );
  }
}