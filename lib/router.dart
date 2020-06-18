import 'package:bynextcourier/bloc/LoginFormBloc.dart';
import 'package:bynextcourier/repository/token_repository.dart';
import 'package:bynextcourier/screen/login.dart';
import 'package:bynextcourier/screen/splash.dart';
import 'package:bynextcourier/screen/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/splash_bloc.dart';
import 'screen/home_screen.dart';

const homeRoute = 'home';
const loginRoute = 'login';
const splashRoute = 'splash';
const webRoute = 'web';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) {
          Widget page;
          switch (settings.name) {
            case homeRoute:
              page = HomeScreen();
              break;
            case splashRoute:
              page = MultiBlocProvider(
                providers: [BlocProvider(create: (context) => SplashBloc()..start())],
                child: BlocListener<SplashBloc, SplashState>(
                  listener: (context, state) {
                    if (state is SplashDone) {
                      Navigator.of(context).pushReplacementNamed(loginRoute);
                    }
                  },
                  child: SplashScreen(),
                ),
              );
              break;
            case loginRoute:
              page = MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => LoginFormBloc()
                      ..tokenRepository = context.repository<TokenRepository>(),
                    ),
                  ],
                  child: BlocListener<LoginFormBloc, LoginFormState>(
                      listener: (context, loginFormState) {
                        if (loginFormState is LoginFormDone) {
                          Navigator.of(context).pushReplacementNamed(homeRoute);
                        }
                      },
                      child: LoginScreen()));
              break;
            case webRoute:
              final args = settings.arguments as Map;
              page = WebViewScreen(url: args['url']);
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
