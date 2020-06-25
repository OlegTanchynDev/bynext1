import 'package:bynextcourier/bloc/forgot_password_bloc.dart';
import 'package:bynextcourier/generated/l10n.dart';
import 'package:bynextcourier/helpers/utils.dart';
import 'package:bynextcourier/view/app_bar_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String username;

    return Scaffold(
      appBar: AppBar(
        title: AppBarLogo(),
        centerTitle: true,
        actions: <Widget>[const SizedBox(width: 50)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 8.0),
          child: LayoutBuilder(builder: (context, constraint) {
            print(constraint);
            print(MediaQuery.of(context).viewInsets);
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraint.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.headline3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          S.of(context).forgotPasswordHeader,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          S.of(context).forgotPasswordText,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        BlocConsumer(
                            bloc: BlocProvider.of<ForgotPasswordBloc>(context),
                            listener: (context, state) async {
                              if (state is ForgotFormDone || (state is ForgotFormReady && state.error != null)) {
                                await showCustomDialog(
                                  context,
                                  message: state is ForgotFormReady
                                      ? state.error['non_field_errors']
                                      : S.of(context).forgotPasswordResponseOk,
                                  button: FlatButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      if (state is ForgotFormDone) {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  ),
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
//                                      errorText:  state is ForgotFormReady && state.error != null ? state.error['username'] : null,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (val) => username = val,
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                ],
                              );
                            }),
                        const SizedBox(height:30.0),
                        Text(
                          S.of(context).forgotPasswordNote,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 18.0),
                        Text(S.of(context).forgotPasswordNotesText, textAlign: TextAlign.justify,),
                        Expanded(
                          child: const SizedBox(
                            height: 0,
                          ),
                        ),
                        BlocBuilder(
                          bloc: BlocProvider.of<ForgotPasswordBloc>(context),
                          builder: (context, state) {
                            return RaisedButton(
                              child: Text('Reset your password'),
                              onPressed: state is ForgotFormReady ? () => context.bloc<ForgotPasswordBloc>().submit(username) : null,
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
