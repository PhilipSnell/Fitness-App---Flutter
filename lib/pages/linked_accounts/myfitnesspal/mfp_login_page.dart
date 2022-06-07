import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xcell/pages/linked_accounts/myfitnesspal/mfp_api.dart';
import 'package:xcell/pages/linked_accounts/myfitnesspal/status_bloc/mfp_status_bloc.dart';

import 'bloc/mfp_bloc.dart';
import 'mfp_login_form.dart';

class MfpLoginPage extends StatelessWidget {
  final MfpApi mfpApi;
  MfpLoginPage({Key key, @required this.mfpApi})
      : assert(mfpApi != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return MfpBloc(
              mfpApi: mfpApi,
              mfpStatusBloc: BlocProvider.of<MfpStatusBloc>(context));
        },
        child: MFPLoginForm(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white60,
          size: 30,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () => Navigator.pop(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
