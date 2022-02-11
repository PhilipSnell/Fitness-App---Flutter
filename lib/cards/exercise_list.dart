import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xcell/api_connection/api_connection.dart';
import 'package:xcell/common/loading_indicator.dart';
import 'package:xcell/database/exercise_database.dart';
import 'package:xcell/popups/video_popup.dart';
import 'package:xcell/theme/style.dart';

import 'exercise_card.dart';

class ExerciseList extends StatefulWidget {
  @override
  _ExerciseListState createState() => new _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {

  TextEditingController controller = new TextEditingController();
  final db = ExerciseDatabase.instance;
  List<dynamic> _list = [];
  List<dynamic> _exercises = [];
  // Get json result and convert it to model. Then add
  Future<Null> _getExercises() async {
    // await trainingApiProvider().getExerciseData();
    var list = await db.queryAllRows();

    _exercises = list;

  }

  @override
  void initState() {
    super.initState();

    _getExercises();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new Container(
            color: Theme.of(context).primaryColor,
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Card(
                child: new ListTile(
                  leading: new Icon(Icons.search),
                  title: new TextField(
                    controller: controller,
                    decoration: new InputDecoration(
                        hintText: 'Search', border: InputBorder.none),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                    controller.clear();
                    onSearchTextChanged('');
                  },),
                ),
              ),
            ),
          ),
          new Expanded(
            child: _list.length != 0 || controller.text.isNotEmpty
                ? new ListView.builder(
                        itemCount: _list.length,
                        itemBuilder: (context, index) {
                          return exerciseCard(_list[index], context);
                        },
                      )
                : new ListView.builder(
                        itemCount: _exercises.length,
                        itemBuilder: (context, index) {
                          return exerciseCard(_exercises[index], context);
                        },
                      ),
          ),
        ],
      ),

    );
  }

  onSearchTextChanged(String text) async {
    _list.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _exercises.forEach((exercise) {
      if (exercise["name"].toLowerCase().contains(text.toLowerCase()) || exercise["description"].toLowerCase().contains(text.toLowerCase()))
        _list.add(exercise);
    });

    setState(() {});
  }
}





