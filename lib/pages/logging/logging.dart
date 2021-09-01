import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xcell/api_connection/api_connection.dart';
import "package:xcell/bloc/authentication_bloc.dart";
import 'package:xcell/cards/group_card.dart';
import 'package:xcell/cards/training_card.dart';
import 'package:xcell/theme/style.dart';
class LoggingPage extends StatefulWidget {
  const LoggingPage({Key key}) : super(key: key);

  @override
  _LoggingPageState createState() => _LoggingPageState();
}

class _LoggingPageState extends State<LoggingPage> {
  List<dynamic> _groups = [];

  Future<Null> _getGroupData() async {
    var list = await getGroupData();
    setState(() {
      _groups = list;
    });
  }

  @override
  void initState(){
    _groups = [];
    _getGroupData();
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Grid List';

    return Scaffold(
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(_groups.length, (index) {
            return groupCard(_groups[index], context, index);
          }),

        ),

    );
  }
}
