import 'package:bynextcourier/bloc/shift_details_bloc.dart';
import 'package:bynextcourier/bloc/tasks_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/repository/tasks_repository.dart';
import 'package:bynextcourier/screen/forgot_password.dart';
import 'package:bynextcourier/screen/shifts.dart';
import 'package:bynextcourier/screen/tasks.dart';
import 'package:bynextcourier/screen/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/forgot_password_bloc.dart';
import 'repository/token_repository.dart';
import 'screen/issues.dart';
import 'screen/my_salary.dart';
import 'screen/navigation_settings.dart';

const webRoute = 'web';
const forgotPasswordRoute = 'forgotPassword';
const tasksRoute = 'tasks';
const navigationSettingsRoute = 'navigationSettings';
const shiftsRoute = 'shifts';
const mySalaryRoute = 'mySalary';
const issuesRoute = 'issues';

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
              page = WebViewScreen(
                url: args['url'],
                title: args['title'] ?? '',
              );
              break;
            case forgotPasswordRoute:
              page = BlocProvider(
                  create: (context) => ForgotPasswordBloc()..tokenRepository = context.repository<TokenRepository>(),
                  child: ForgotPasswordScreen());
              break;
            case tasksRoute:
              page = BlocProvider(
                  create: (context) => TasksListBloc()
                    ..repository = context.repository<TasksRepository>()
                    ..tokenBloc = context.bloc<TokenBloc>()
                    ..shiftDetailsBloc = context.bloc<ShiftDetailsBloc>(),
                  child: TasksScreen());
              break;
            case navigationSettingsRoute:
              page = NavigationSettingsScreen();
              break;
            case shiftsRoute:
              page = ShiftsScreen();
              break;
            case mySalaryRoute:
              page = MySalaryScreen();
              break;
            case issuesRoute:
              page = IssuesScreen();
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
