import 'package:bynextcourier/bloc/forgot_password_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    String username;
    String password;

    return BlocProvider(
      create: (_) => ForgotPasswordBloc(),
      child: Scaffold(
        appBar: AppBar(
          title:  Center(
            child: Image(
              image: AssetImage('assets/images/logo.png')
            ),
          ),
          automaticallyImplyLeading: true,
        ),
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
                          SizedBox(
                            height: 20.0,
                          ),
                          Text("Forgot your password"),
                          const SizedBox(height: 40),
                          Text("Please send your email to reset your password"),
                          SizedBox(
                            height: 20,
                          ),

                          BlocConsumer(
                            bloc: BlocProvider.of<ForgotPasswordBloc>(context),
                            listener: (context, state) async {
                              if (state is LoginFormReady && state.error != null && state.error['non_field_errors'] != null){
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Align(
                                      child: Container(
                                        width: 250,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  state.error['non_field_errors'],
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.normal,
                                                    fontStyle: FontStyle.normal,
                                                    color: Colors.black,
                                                    decoration: TextDecoration.none,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            RaisedButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            SizedBox(
                                              height: 5,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                );
                              }
                            },
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
                                  )
                                ],
                              );
                            }
                          ),
                          Text("Note:"),
                          const SizedBox(
                            height: 16.0,
                          ),
                          Text("The password ..."),
                          Expanded(
                            child: SizedBox(
                              height: 0,
                            ),
                          ),
                          RaisedButton(
                            child: Text('Reset >>'),
                            onPressed: () =>
                              context.bloc<ForgotPasswordBloc>().submit(
                                username, password),
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
      ),
    );
  }
}