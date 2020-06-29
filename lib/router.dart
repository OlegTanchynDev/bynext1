import 'package:bynextcourier/bloc/shift_details_bloc.dart';
import 'package:bynextcourier/bloc/tasks_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/repository/schedule_repository.dart';
import 'package:bynextcourier/repository/tasks_repository.dart';
import 'package:bynextcourier/screen/forgot_password.dart';
import 'package:bynextcourier/screen/shifts.dart';
import 'package:bynextcourier/screen/tasks.dart';
import 'package:bynextcourier/screen/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/forgot_password_bloc.dart';
import 'bloc/http_client_bloc.dart';
import 'bloc/issues_bloc.dart';
import 'bloc/payment_bloc.dart';
import 'bloc/schedule_bloc.dart';
import 'repository/issues_repository.dart';
import 'repository/payment_repository.dart';
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
                  create: (context) => ForgotPasswordBloc()
                    ..tokenRepository = context.repository<TokenRepository>()
                    ..httpClientBloc = context.bloc<HttpClientBloc>(),
                  child: ForgotPasswordScreen());
              break;
            case tasksRoute:
              page = BlocProvider(
                  create: (context) => TasksListBloc()
                    ..repository = context.repository<TasksRepository>()
                    ..tokenBloc = context.bloc<TokenBloc>()
                    ..httpClientBloc = context.bloc<HttpClientBloc>()
                    ..shiftDetailsBloc = context.bloc<ShiftDetailsBloc>(),
                  child: TasksScreen());
              break;
            case navigationSettingsRoute:
              page = NavigationSettingsScreen();
              break;
            case shiftsRoute:
              page = BlocProvider(
                  create: (context) => ScheduleBloc()
                    ..repository = context.repository<ScheduleRepository>()
                    ..tokenBloc = context.bloc<TokenBloc>()
                    ..httpClientBloc = context.bloc<HttpClientBloc>()
                    ..add(ScheduleLoad()),
                  child: ShiftsScreen());
              break;
            case mySalaryRoute:
              page = BlocProvider(
                  create: (context) => PaymentBloc()
                    ..tokenBloc = context.bloc<TokenBloc>()
                    ..httpClientBloc = context.bloc<HttpClientBloc>()
                    ..repository = context.repository<PaymentRepository>(),
                  child: MySalaryScreen());
              break;
            case issuesRoute:
              page = BlocProvider(
                  create: (context) => IssuesBloc()
                    ..tokenBloc = context.bloc<TokenBloc>()
                    ..httpClientBloc = context.bloc<HttpClientBloc>()
                    ..repository = context.repository<IssueRepository>(),
                  child: IssuesScreen());
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
