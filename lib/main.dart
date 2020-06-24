import 'package:bynextcourier/bloc/login_form_bloc.dart';
import 'package:bynextcourier/bloc/delegate/bloc_delegate.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/repository/token_repository.dart';
import 'package:bynextcourier/screen/home_screen.dart';
import 'package:bynextcourier/screen/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';

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
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                  lazy: false,
                  create: (context) => (TokenBloc()
                    ..add(ValidateToken())
                    ..repository = context.repository<TokenRepository>()))
            ],
            child: MaterialApp(
                title: 'ByNext',
                theme: ThemeData(
                  brightness: Brightness.light,
                  primarySwatch: Colors.grey,
                  scaffoldBackgroundColor: const Color(0xFFF2EDEB),
                  colorScheme: const ColorScheme(
                    brightness: Brightness.light,
                    primary: const Color(0xFF232456),
                    primaryVariant: const Color(0xFF4a4a4a),
                    secondary: const Color(0xFF232456),
                    // <-- text color
                    secondaryVariant: const Color(0xFF848484),
                    surface: const Color(0xFF232456),
                    background: const Color(0xFFF2EDEB),
                    error: Colors.red,
                    onPrimary: const Color(0xFFF2EDEB),
                    onSecondary: const Color(0xFFF2EDEB),
                    onBackground: const Color(0xFF232456),
                    onError: const Color(0xFFFFDDDD),
                    onSurface: const Color(0xFF232456), // <-- disabled text color, INPUT DECORATION
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
                        color: Color(0xFF232456),
                      ),


                      headline3: const TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF232456),
                      ),


                      headline6: const TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF232456),
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
                            child: LoginScreen(),
                          );
                          break;
                      }
                    })),
                onGenerateRoute: Router.generateRoute,
//            initialRoute: splashRoute,
                localizationsDelegates: [
                  S.delegate,
                ]),
          ),
        ));
  }
}
