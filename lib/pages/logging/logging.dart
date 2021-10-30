
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xcell/api_connection/TrackingData.dart';
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
  DateTime day = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

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
        appBar: AppBar(
            title: Row(
              children: [
                IconButton(
                    onPressed: (){
                      setState(() {
                        day = DateTime(day.year,day.month,day.day-1);
                      });

                    },
                    icon: Icon(Icons.arrow_back_ios, color: featureColor),
                ),
                Center(
                child: calculateDifference(day)==0
                  ? Text("Today")
                  : calculateDifference(day)==1
                    ? Text("Tomorrow")
                    : calculateDifference(day)==-1
                      ? Text("Yesterday")
                      : Text("${DateFormat('MMMEd').format(day)}")
                ),
                IconButton(
                  onPressed: (){
                    setState(() {
                      day = DateTime(day.year,day.month,day.day+1);
                    });
                  },
                  icon: Icon(Icons.arrow_forward_ios, color: featureColor),
                ),
              ],
            ),
        ),
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(_groups.length, (index) {
            return groupCard(
                item: _groups[index],
                day: day,
                index: index
            );
          }),

        ),

    );
  }
}
int calculateDifference(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
}