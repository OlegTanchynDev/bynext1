import 'package:bynextcourier/screen/login.dart';
import 'package:bynextcourier/screen/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/splash_bloc.dart';

const String homeRoute = '/';
const String loginRoute = 'login';
const String splashRoute = 'splash';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) {
          Widget page;
          switch (settings.name) {
//      case homeRoute:
//        return MaterialPageRoute(builder: (_) => Home());
            case splashRoute:
              page =  MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => SplashBloc()..start())
                ],
                child: BlocListener<SplashBloc, SplashState>(
                  listener: (context, state) {
                    if (state is SplashDone) {
                      Navigator.of(context)
                          .popAndPushNamed(loginRoute);
                    }
                  },
                  child: SplashScreen(),
                ),
              );
              break;
            case loginRoute:
              page = LoginScreen();
              break;
            default:
              page = Scaffold(
                body: Center(child: Text('No route defined for ${settings.name}')),
              );
          }
          return GestureDetector(onTap: () => FocusScope.of(context).requestFocus(new FocusNode()), child: page);
        });
  }
}
