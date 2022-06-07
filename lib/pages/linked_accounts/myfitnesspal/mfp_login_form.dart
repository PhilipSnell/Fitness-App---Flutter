import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xcell/pages/linked_accounts/myfitnesspal/status_bloc/mfp_status_bloc.dart';
import 'package:xcell/theme/my_flutter_app_icons.dart';

import 'bloc/mfp_bloc.dart';

class MFPLoginForm extends StatefulWidget {
  @override
  State<MFPLoginForm> createState() => _MFPLoginFormState();
}

class _MFPLoginFormState extends State<MFPLoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onConnectButtonPressed() {
      BlocProvider.of<MfpBloc>(context).add(Connect(
        username: _usernameController.text,
        password: _passwordController.text,
      ));
    }

    _onDisconnectButtonPressed() {
      BlocProvider.of<MfpBloc>(context).add(Disconnect());
    }

    return BlocListener<MfpBloc, MfpState>(
      listener: (context, state) {
        if (state is ConnectFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Incorrect MyFitnessPal login details',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ));
        }
      },
      child: BlocBuilder<MfpBloc, MfpState>(
        builder: (context, state1) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(40, 60, 40, 0),
                  child: Container(
                    height: 60,
                    width: 60,
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3))),
                        ),
                        Icon(
                          CustomIcons.mfp,
                          color: Color(0xff2853BA),
                          size: 60,
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<MfpStatusBloc, MfpStatusState>(
                    builder: (context, state) {
                  if (state is MfpDisconnected) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Connect your MyFitnessPal account!",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Form(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Username',
                                      icon: Icon(Icons.person)),
                                  controller: _usernameController,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    icon: Icon(Icons.security),
                                  ),
                                  controller: _passwordController,
                                  obscureText: true,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  height:
                                      MediaQuery.of(context).size.width * 0.22,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 30.0),
                                    child: ElevatedButton(
                                      onPressed: state1 is! ConnectLoading
                                          ? _onConnectButtonPressed
                                          : null,
                                      child: Text(
                                        'Connect',
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xff2853BA),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: state1 is ConnectLoading
                                      ? CircularProgressIndicator()
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Disconnect from MyFitnessPal",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.width * 0.22,
                          child: Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: ElevatedButton(
                              onPressed: state1 is! ConnectLoading
                                  ? _onDisconnectButtonPressed
                                  : null,
                              child: Text(
                                'Disconnect',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xff2853BA),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: state1 is ConnectLoading
                              ? CircularProgressIndicator()
                              : null,
                        ),
                      ],
                    );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
