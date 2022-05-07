import 'package:flutter/material.dart';
import 'package:xcell/theme/style.dart';

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
          mfpCard(),
        ],
      ),
    );
  }
}

class mfpCard extends StatefulWidget {
  const mfpCard({Key key}) : super(key: key);

  @override
  State<mfpCard> createState() => _mfpCardState();
}

class _mfpCardState extends State<mfpCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("MyFitnessPal"),
    );
  }
}
