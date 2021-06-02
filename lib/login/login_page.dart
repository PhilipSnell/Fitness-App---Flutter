import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xcell/login/sbloc/signup_bloc.dart';
import 'package:xcell/login/sign_up_form.dart';
import 'package:xcell/repository/user_repository.dart';

import 'package:xcell/bloc/authentication_bloc.dart';
import 'package:xcell/login/bloc/login_bloc.dart';
import 'package:xcell/login/login_form.dart';
import 'package:xcell/theme/style.dart';

class LoginPage extends StatelessWidget {
  final UserRepository userRepository;

  LoginPage({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: appLogo,
      // ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              tabs: [
                Tab(text: "Sign In"),
                Tab(text: "Sign up"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              BlocProvider(
                create: (context) {
                  return LoginBloc(
                  authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                  userRepository: userRepository,
                  );
                },
                child: LoginForm(),

              ),
              BlocProvider(
                create: (context) {
                  return SignupBloc(
                    userRepository: userRepository,
                  );
                },
                child: SignupForm(),

              ),
            ],
          ),
        ),
      ),
    );
  }
}