import 'package:bynextcourier/screen/forgot_password.dart';
import 'package:bynextcourier/screen/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/forgot_password_bloc.dart';
import 'repository/token_repository.dart';

const webRoute = 'web';
const forgotPasswordRoute = 'forgotPassword';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) {
          Widget page;
          switch (settings.name) {
//            case homeRoute:
//              page = HomeScreen();
//              break;
//            case splashRoute:
//              page = MultiBlocProvider(
//                providers: [BlocProvider(create: (context) => SplashBloc()..start())],
//                child: BlocListener<SplashBloc, SplashState>(
//                  listener: (context, state) {
//                    if (state is SplashDone) {
//                      Navigator.of(context).pushReplacementNamed(loginRoute);
//                    }
//                  },
//                  child: SplashScreen(),
//                ),
//              );
//              break;
//            case loginRoute:
//              page = MultiBlocProvider(
//                  providers: [
//                    BlocProvider(
//                      create: (context) => LoginFormBloc()
//                      ..tokenRepository = context.repository<TokenRepository>(),
//                    ),
//                  ],
//                  child: BlocListener<LoginFormBloc, LoginFormState>(
//                      listener: (context, loginFormState) {
//                        if (loginFormState is LoginFormDone) {
////                          Navigator.of(context).pushReplacementNamed(homeRoute);
//                        }
//                      },
//                      child: LoginScreen()));
//              break;
            case webRoute:
              final args = settings.arguments as Map;
              page = WebViewScreen(url: args['url']);
              break;
            case forgotPasswordRoute:
              page = BlocProvider(
                  create: (context) => ForgotPasswordBloc()..tokenRepository = context.repository<TokenRepository>(),
                  child: ForgotPasswordScreen());
              break;
            default:
              page = Scaffold(
                appBar: AppBar(),
                body: Center(child: Text('No route defined for ${settings.name}')),
              );
          }
          return GestureDetector(onTap: () => FocusScope.of(context).requestFocus(new FocusNode()), child: page);
        });
  }
}
