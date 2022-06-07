import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xcell/pages/linked_accounts/myfitnesspal/mfp_api.dart';
import 'package:xcell/pages/linked_accounts/myfitnesspal/status_bloc/mfp_status_bloc.dart';
import 'package:xcell/theme/my_flutter_app_icons.dart';
import 'package:xcell/theme/style.dart';

import 'myfitnesspal/mfp_login_page.dart';

class LinkedAccountPage extends StatefulWidget {
  const LinkedAccountPage({Key key}) : super(key: key);

  @override
  _LinkedAccountPageState createState() => _LinkedAccountPageState();
}

class _LinkedAccountPageState extends State<LinkedAccountPage> {
  List<dynamic> _groups = [];
  DateTime day = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  ValueNotifier<bool> _notifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final title = 'Grid List';

    return Scaffold(
      body: Column(
        children: [
          MfpCard(),
        ],
      ),
    );
  }
}

class MfpCard extends StatefulWidget {
  const MfpCard({Key key}) : super(key: key);

  @override
  State<MfpCard> createState() => _MfpCardState();
}

class _MfpCardState extends State<MfpCard> {
  final mfpApi = MfpApi();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MfpLoginPage(
                      mfpApi: mfpApi,
                    ))),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: double.infinity,
            height: 50,
            color: linkedAccountBackground,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                  child: Container(
                    height: 30,
                    width: 30,
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.all(2),
                          color: Colors.white,
                        ),
                        Icon(
                          CustomIcons.mfp,
                          color: Color(0xff2853BA),
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                  child: Text(
                    "My Fitness Pal",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<MfpStatusBloc, MfpStatusState>(
                    builder: (context, state) {
                      if (state is MfpDisconnected) {
                        return Icon(
                          FontAwesomeIcons.unlink,
                          color: Color.fromARGB(255, 153, 153, 153),
                        );
                      }
                      if (state is MfpConnected) {
                        return Icon(
                          FontAwesomeIcons.link,
                          color: Color.fromARGB(255, 102, 179, 104),
                        );
                      } else
                        return CircularProgressIndicator();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
