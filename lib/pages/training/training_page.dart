import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xcell/api_connection/api_connection.dart';
import 'package:xcell/pages/training/card_dropdown.dart';
import 'package:xcell/database/exercise_database.dart';
import 'package:xcell/database/training_database.dart';
import 'package:xcell/models/training_entry.dart';
import 'package:xcell/pages/training/training_card.dart';
import 'package:xcell/theme/style.dart';


class TrainingPage1 extends StatefulWidget {
  @override
  _TrainingPage1State createState() => new _TrainingPage1State();
}

class _TrainingPage1State extends State<TrainingPage1> {
  List<bool> _display; // true if dropdown is open, false otherwise
  final t_db = DatabaseHelper.instance;
  bool submit_allowed =false;
  TextEditingController controller = new TextEditingController();
  final db = ExerciseDatabase.instance;
  List<dynamic> _list = [];
  List<TrainingEntry> _trainingEntrys = [];
  // Get json result and convert it to model. Then add
  Future<Null> _queryTainingAPI() async {
    await trainingApiProvider().getTrainingData();
    var list = await t_db.queryAllRows();
    setState(() {
      _trainingEntrys = list;
    });
    onDayChanged();
  }

  Future<void> _pullRefresh() async {
    _queryTainingAPI();
  }

  int selectedDay = 0;
  Future<int> _getDays() async {
    return t_db.getDays();
  }

  @override
  void initState() {
    super.initState();
    _queryTainingAPI();
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new Container(
            height: 7,
          ),
          // -------------------------------------------------------------------------
          // Day Selector
          // -------------------------------------------------------------------------
          FutureBuilder<int>(
              future: _getDays(),
              builder: (context, days) {
                if (days.hasData) {
                  return Container(
                    height: 50,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: days.data,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 120,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20.0),
                                  onTap: () => setState(() {
                                    selectedDay = index;
                                    onDayChanged();
                                  }),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    color: selectedDay == index
                                        ? dayBackSelected
                                        : dayBackNotSelected,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Day ${index + 1}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: selectedDay == index
                                              ? dayTextSelected
                                              : dayTextNotSelected,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          Expanded(
            child: Container(
              child: RefreshIndicator(
                  onRefresh: _pullRefresh,
                  child: _list.length != 0
                      ? new ListView.builder(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: _list.length,
                          itemBuilder: (context, index) {
                            // return Text("Submit");
                            return Padding(
                              padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: Container(
                                  color: cardDropDown,
                                  // height: 110,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _display[index] = !_display[index];
                                          });
                                        },
                                        child: TrainingCard(
                                          exercise: _list[index].exerciseId,
                                          reps: _list[index].reps,
                                          weight: _list[index].weight,
                                          sets: _list[index].sets,
                                          id: _list[index].id,
                                          comment: _list[index].comment,
                                          setSubmitAllowed: (bool value) {
                                            setState(() {
                                              submit_allowed = value;
                                            });
                                          },
                                        ),
                                      ),
                                      CardDropDown(
                                        display: _display[index],
                                        reps: _list[index].reps,
                                        weight: _list[index].weight,
                                        t_id: _list[index].id,
                                        e_id: _list[index].exerciseId,
                                        setSubmitAllowed: (bool value) {
                                          setState(() {
                                            submit_allowed = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(child: CircularProgressIndicator())),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          syncSetData();
          setState(() {
            submit_allowed = false;
          });
        },
        child: Text("Submit",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor:  submit_allowed ? featureColor: cardBack,

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  onDayChanged() async {
    _list.clear();
    _display = [];

    _trainingEntrys.forEach((entry) {
      _display.add(false);
      print(entry);
      // print("Day num:");
      // print(entry.day);
      if (entry.day == selectedDay + 1) {
        _list.add(entry);
      }
    });
  }
}
