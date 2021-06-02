import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xcell/common/common.dart';
import 'package:xcell/database/exercise_database.dart';
import 'package:xcell/database/set_database.dart';
import 'package:xcell/database/training_database.dart';
import 'package:xcell/models/training_set.dart';
import 'package:xcell/pages/training/training_page.dart';
import 'package:xcell/theme/style.dart';
import 'package:xcell/popups/video_popup.dart';


class CardDropDown extends StatefulWidget {
  final String reps;
  final String weight;
  final int t_id;
  final int e_id;
  final bool display;
  final Function(bool) setSubmitAllowed;

  const CardDropDown({
    Key key,
    this.display,
    this.reps,
    this.weight,
    this.t_id,
    this.e_id,
    this.setSubmitAllowed,
  }) : super(key: key);

  @override
  _CardDropDownState createState() => _CardDropDownState();
}

class _CardDropDownState extends State<CardDropDown> {
  // need to load the itemList from db
  final set_db = SetDatabase.instance;
  final db = ExerciseDatabase.instance;

  TrainingSet defaultSet ;

  //Map<String, String> reps = {};

  void takeReps(String text, int index,List<TrainingSet> list) {
    try {
      print("Before: ${list[index].reps}");
      list[index].reps = text;
      print("After: ${list[index].reps}");
    } on FormatException {}
    saveList(list);
    widget.setSubmitAllowed(true);
  }
  void takeWeight(String text, int index, List<TrainingSet> list){
    try {
      print("Before: ${list[index].weights}");
      list[index].weights = text;
      print("After: ${list[index].weights}");
    } on FormatException {}
    saveList(list);
    widget.setSubmitAllowed(true);
  }

  Future<List<TrainingSet>> loadList() async{
    // Map<String, dynamic> item;
    // SetDatabase.deleteDB();
    var sets = set_db.queryID(widget.t_id, widget.reps, widget.weight, widget.e_id,);
    return sets;
  }

  void saveList(List<TrainingSet> list) async{
    String reps ="";
    String weights = "";
    Map<String, dynamic> row;
    if(list.isEmpty){
      await set_db.delete(widget.t_id);
      print("Removing last set");
      loadList();
    }else {
      for (TrainingSet item in list) {
        reps = "$reps${item.reps},";
        weights = "$weights${item.weights},";
      }
      if (reps != null && reps.length > 0) {
        reps = reps.substring(0, reps.length - 1);
        weights = weights.substring(0, weights.length - 1);
      }
      // List<String> result = reps.split(',');
      // print("String length: ${result}");
      //Map<String, dynamic> row = ;
      //print("This is ID: ${itemList[0].id}");
      row = {
        't_id': list[0].t_id,
        'sets': list.length,
        'reps': reps,
        'weights': weights,
        'e_id': list[0].e_id,
      };
      print("INSERTING :$row");
      var result = await set_db.insert(row);
      if(result==null){
        print("Set already existed ... updating");
        await set_db.update(row);
      }
      else{
        print("Successfully added $row");
      }

    }
    setState(() {
      print("save completed");
    });
    //loadList();
  }

  @override
  void initState() {

    super.initState();
    defaultSet = TrainingSet(t_id: widget.t_id, sets: 1, reps: widget.reps, weights: widget.weight, e_id: widget.e_id);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.display,
      child: Container(
        color: cardDropDown,
        child: FutureBuilder<List<TrainingSet>>(
          future: loadList(),
          builder: (context, listOfSets) {
            if(listOfSets.hasData){

              return Column(
                //mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listOfSets.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TrainSet(listOfSets.data,index);
                      }
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: listOfSets.data.length > 0 ? true : false,
                        child: IconButton(
                            icon: Icon(
                              Icons.remove,
                              color: cardAddIcon,
                            ),
                            padding: listOfSets.data.length > 0
                                ? EdgeInsets.only(right: 15)
                                : EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            onPressed: () {
                              listOfSets.data.removeLast();
                              saveList(listOfSets.data);
                              widget.setSubmitAllowed(true);
                            }
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.add,
                            color: cardAddIcon,
                          ),
                          padding: listOfSets.data.length > 0 ? EdgeInsets.only(left: 15) : EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () {
                            listOfSets.data.add(defaultSet);
                            saveList(listOfSets.data);
                            widget.setSubmitAllowed(true);
                          }
                      ),
                    ],
                  ),
                ],
              );
            }else{
              return Center(child: CircularProgressIndicator());
            }
          }
        ),
      ),
    );
  }

  Widget TrainSet(List<TrainingSet> list, int index) {
    //TextEditingController _repsController = TextEditingController().text;

    if (index ==list.length){
      list.add(defaultSet);
    }
    print(list[index].reps);
    TrainingSet item = list[index];

    return Container(
      color: index.isOdd ? Color(0xff6D6D6D) : cardDropDown,

      child: Padding(
        padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                color: background,
                height: 27,
                //margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Center(
                    child: Text(
                        "Set ${index + 1}", textAlign: TextAlign.center),
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                height: 27,
                color: background,
                child: Row(
                  children: [
                    Container(
                      height: 27,
                      color: cardBack,
                      child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Center(
                          child: Text("reps",
                              style: TextStyle(color: cardDropText)
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 27,
                      width: 50,
                      color: background,
                      child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Center(
                          child: TextFormField(
                            decoration: new InputDecoration(
                              enabledBorder: InputBorder.none,
                            ),
                            initialValue: item.reps,
                            onChanged: (text) {
                              takeReps(text, index, list);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                height: 27,
                color: background,
                child: Row(
                  children: [
                    Container(
                      height: 27,
                      color: cardBack,
                      child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Center(
                          child: Text("weight",
                              style: TextStyle(color: cardDropText)
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 27,
                      width: 50,
                      color: background,
                      child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Center(
                          child: TextFormField(
                            decoration: new InputDecoration(
                              enabledBorder: InputBorder.none,
                            ),
                            initialValue: item.weights,
                            onChanged: (text) {
                              takeWeight(text, index, list);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}




