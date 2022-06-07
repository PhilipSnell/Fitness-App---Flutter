import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xcell/authentication/bloc/authentication_bloc.dart';
import 'package:xcell/authentication/login/login_page.dart';
import 'package:xcell/common_widgets/loading_indicator.dart';
// import 'package:xcell/pages/linked_accounts/myfitnesspal/bloc/mfp_bloc.dart';
import 'package:xcell/pages/linked_accounts/myfitnesspal/mfp_api.dart';
import 'package:xcell/pages/main_nav/page_display.dart';
import 'package:xcell/pages/splash/splash_page.dart';
import 'package:xcell/repository/user_repository.dart';
import 'package:xcell/theme/style.dart';

import 'pages/linked_accounts/myfitnesspal/status_bloc/mfp_status_bloc.dart';
import 'theme/colors.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
  }
}

void main() {
  initializeDateFormatting('fr_FR', null);
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepository = UserRepository();
  final mfpApi = MfpApi();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthenticationBloc>(
        create: (context) {
          return AuthenticationBloc(userRepository: userRepository)
            ..add(AppStarted());
        },
      ),
      BlocProvider<MfpStatusBloc>(
        create: (context) {
          return MfpStatusBloc(mfpApi: mfpApi)..add(MfpAppStarted());
        },
      )
    ],
    child: App(
      userRepository: userRepository,
    ),
  ));
}

class App extends StatelessWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: MyYellow,
        accentColor: featureColor,
        focusColor: featureColor,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: background,
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Color(0x232323), //Set to see through
        ),
        // textSelectionHandleColor: Colors.green,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationUnintialized) {
            return SplashPage();
          }
          if (state is AuthenticationAuthenticated) {
            return MyPage();
          }
          if (state is AuthenticationUnauthenticated) {
            return LoginPage(
              userRepository: userRepository,
            );
          }
          if (state is AuthenticationLoading) {
            return LoadingIndicator();
          } else
            return LoginPage(
              userRepository: userRepository,
            );
        },
      ),
    );
  }
}
