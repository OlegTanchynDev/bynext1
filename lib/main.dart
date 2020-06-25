import 'package:bynextcourier/bloc/delegate/bloc_delegate.dart';
import 'package:bynextcourier/bloc/login_form_bloc.dart';
import 'package:bynextcourier/bloc/maps_bloc.dart';
import 'package:bynextcourier/bloc/profile_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/repository/profile_repository.dart';
import 'package:bynextcourier/repository/token_repository.dart';
import 'package:bynextcourier/screen/home_screen.dart';
import 'package:bynextcourier/screen/splash.dart';
import 'package:bynextcourier/view/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';

import 'bloc/location_tracker/location_tracker_bloc.dart';
import 'generated/l10n.dart';
import 'router.dart';
import 'screen/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    BlocSupervisor.delegate = SimpleBlocDelegate();

    // primary color
    const primaryColor = const Color(0xFF232456);

    // appbar color
    const primaryVariantColor = Color(0xFF4a4a4a);

    const textColor = Color(0xFF232456);

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => DrawerMenuState(),
          ),
        ],
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider(
              create: (_) => TokenRepository(),
            ),
            RepositoryProvider(
              create: (_) => ProfileRepository(),
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                  lazy: false,
                  create: (context) => (TokenBloc()
                    ..add(ValidateToken())
                    ..repository = context.repository<TokenRepository>())
              ),
              BlocProvider(
                create: (context) => ProfileBloc()..tokenBloc = context.bloc<TokenBloc>()..repository = context.repository<ProfileRepository>(),
              ),
              BlocProvider(
                lazy: false,
                create: (_) => LocationTrackerBloc()..startLocationTracking(),
              ),
              BlocProvider(
                lazy: false,
                create: (_) => MapsBloc()..add(CheckInstalled()),
              ),
            ],
            child: MaterialApp(
                title: 'ByNext',
                theme: ThemeData(
                  brightness: Brightness.light,
                  primarySwatch: Colors.grey,
                  scaffoldBackgroundColor: const Color(0xFFF2EDEB),
                  colorScheme: const ColorScheme(
                    brightness: Brightness.light,
                    primary: primaryColor,
                    primaryVariant: primaryVariantColor,
                    secondary: primaryColor,
                    // <-- text color
                    secondaryVariant: const Color(0xFF848484),
                    surface: primaryColor,
                    background: const Color(0xFFF2EDEB),
                    error: Colors.red,
                    onPrimary: const Color(0xFFF2EDEB),
                    onSecondary: const Color(0xFFF2EDEB),
                    onBackground: primaryColor,
                    onError: const Color(0xFFFFDDDD),
                    onSurface: primaryColor, // <-- disabled text color, INPUT DECORATION
                  ),

                  // This makes the visual density adapt to the platform that you run
                  // the app on. For desktop platforms, the controls will be smaller and
                  // closer together (more dense) than on mobile platforms.
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  textTheme: const TextTheme(
                      // edit text
                      subtitle1: const TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                      bodyText2: const TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: textColor,
                      ),

                      headline2: const TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 19,
                        fontWeight: FontWeight.w300,
                        color: primaryColor,
                      ),

                      headline3: const TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                        color: primaryColor,
                      ),
                      headline6: const TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: textColor,
                      ),

                      //buttons
                      button: const TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      )),
                  buttonTheme: const ButtonThemeData(
                    textTheme: ButtonTextTheme.primary,
                    height: 41,
                    buttonColor: const Color(0xFF403D9C),
                  ),
                  inputDecorationTheme: const InputDecorationTheme(
                    isDense: true,
                    border: const OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(0.0))),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  ),
                  dividerTheme: const DividerThemeData(
                    color: const Color(0xFF848484),
                    space: 0,
                    thickness: 1,
                  ),
                  appBarTheme: const AppBarTheme(
                    color: const Color(0xFFF2EDEB),
                    elevation: 0,
                    textTheme: TextTheme(
                      headline6: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                        color: primaryVariantColor,
                      ),
                    ),
                  ),
                ),
                home: GestureDetector(
                    onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
                    child: BlocBuilder<TokenBloc, TokenState>(builder: (context, tokenState) {
                      switch (tokenState.runtimeType) {
                        case TokenInitial:
                          return SplashScreen();
                          break;
                        case TokenValid:
                          return HomeScreen();
                          break;
                        case TokenNull:
                          return BlocProvider(
                            create: (context) => LoginFormBloc()
                              ..tokenBloc = context.bloc<TokenBloc>()
                              ..tokenRepository = context.repository<TokenRepository>(),
                            child: Stack(
                              children: <Widget>[
                                LoginScreen(),
                                BlocBuilder<LoginFormBloc, LoginFormState>(
                                  builder: (context, loginFormState) => loginFormState is LoginFormProcessing
                                      ? CustomProgressIndicator(text: 'You should be good to go\nin a few seconds...')
                                      : Container(),
                                ),
                              ],
                            ),
                          );
                          break;
                        default:
                          return Scaffold(
                            body: Center(child: Text('not implemented screen for state ${tokenState.runtimeType}')),
                          );
                      }
                    })),
                onGenerateRoute: Router.generateRoute,
                localizationsDelegates: [
                  S.delegate,
                ]),
          ),
        ));
  }
}
