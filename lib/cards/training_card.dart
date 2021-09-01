import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xcell/api_connection/api_connection.dart';
import 'package:xcell/cards/card_dropdown.dart';
import 'package:xcell/cards/exercise_card.dart';
import 'package:xcell/common/loading_indicator.dart';
import 'package:xcell/database/exercise_database.dart';
import 'package:xcell/database/training_database.dart';
import 'package:xcell/popups/video_popup.dart';
import 'package:xcell/theme/style.dart';

import 'exercise_list.dart';

class TrainingCard extends StatefulWidget {
  final Function(bool) setSubmitAllowed;
  const TrainingCard({
    Key key,
    this.setSubmitAllowed,
  }) : super(key: key);

  @override
  _TrainingCardState createState() => _TrainingCardState();
}

class _TrainingCardState extends State<TrainingCard> {
  final t_db = DatabaseHelper.instance;
  final e_db = ExerciseDatabase.instance;
  int selectedDay = 0;
  List<bool> _display;
  Future<int> _getDays() async{
    return t_db.getDays();
  }
  Future<List<dynamic>> loadData() async{
    var _training = t_db.queryDayRows(selectedDay+1);
    trainingApiProvider().getTrainingData();

    setState(() {
      print("refreshing");

    });
    return _training;
  }
  Future<void> _pullRefresh() async{
    loadData();
  }

  @override
  void initState(){
    _display = List.generate(50, (index) => false);
    super.initState();
    loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 7,
          ),
          FutureBuilder<int>(
            future:  _getDays(),
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
                                onTap: () =>
                                    setState(() {
                                      selectedDay = index;
                                      loadData();
                                    } ),
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
                                        color:selectedDay == index
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
                      }
                  ),
                );
              }
              else{
                return Center(child: CircularProgressIndicator());
              }
            }
          ),
          Expanded(
            child: Container(

              child: FutureBuilder<List<dynamic>>(
                future: loadData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.hasData){
                    // print(snapshot.data[0]);
                    return RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(15,0,15,15),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index){
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
                                    child: Column(
                                      children:[
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          color:cardBack,
                                          margin: EdgeInsets.only(top:0,left:0,right:0,bottom:2),
                                          child: InkWell(
                                            onTap: (){
                                              setState(() {
                                                _display[index] = !_display[index];
                                              });

                                            },
                                            child: Container(
                                              height: 108,
                                              child:Column(
                                                children: <Widget>[
                                                  ListTile(
                                                    contentPadding: EdgeInsets.fromLTRB(3,0,2,0),
                                                    //leading: Icon(Icons.image, size: 90),
                                                    title: FutureBuilder<Map<String,dynamic>>(
                                                        future: e_db.queryRow(snapshot.data[index]["exercise"]),
                                                        builder: (BuildContext context, AsyncSnapshot exercise) {
                                                          if(exercise.hasData){
                                                            return Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Expanded(
                                                                    child: Card(
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(15.0),
                                                                      ),
                                                                      shadowColor: featureColor,
                                                                      color:  cardBack,
                                                                      child: ClipRRect(
                                                                        borderRadius: BorderRadius.circular(15.0),
                                                                        child: Center(
                                                                          child: new AspectRatio(
                                                                          aspectRatio: 487 / 451,
                                                                            child: new Container(
                                                                              child: CachedNetworkImage(
                                                                                                imageUrl:  "${exercise.data["image"]}",
                                                                                                placeholder: (context, url) => new LoadingIndicator(),
                                                                                                errorWidget: (context, url, error) => new Icon(Icons.error),
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    flex: 6,
                                                                  ),
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                                          child: ClipRRect(
                                                                            borderRadius: BorderRadius.circular(10.0),
                                                                            child: Container(
                                                                              color: background,
                                                                              height:31,
                                                                              child:Center(
                                                                                child: Text("${exercise.data["name"]}",
                                                                                    textAlign: TextAlign.center),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),

                                                                        Container(
                                                                          height:62,
                                                                          child:Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                  children: [
                                                                                    Text("reps",
                                                                                      style: TextStyle(color: cardText),
                                                                                    ),
                                                                                    Text("${snapshot.data[index]['reps']}",
                                                                                      style: TextStyle(color: cardFeatureText),
                                                                                    ),
                                                                                  ]
                                                                              ),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  Text("weight",
                                                                                    style: TextStyle(color: cardText),
                                                                                  ),

                                                                                  Container(
                                                                                    child: Text("${snapshot.data[index]['weight']} ",
                                                                                      style: TextStyle(color: cardFeatureText),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  Text("sets",
                                                                                    style: TextStyle(color: cardText),
                                                                                  ),
                                                                                  Text("${snapshot.data[index]['sets']}",
                                                                                    style: TextStyle(color: cardFeatureText),
                                                                                  ),
                                                                                ],
                                                                              ),

                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),

                                                                    flex: 11,
                                                                  ),
                                                                  Expanded(
                                                                    flex: 4,
                                                                    child:ClipRRect(
                                                                      borderRadius: BorderRadius.circular(15.0),
                                                                      child: Container(
                                                                        height: 93,
                                                                        //color: Colors.blue,

                                                                        child: Column(
                                                                            children: [
                                                                              Expanded(
                                                                                flex:1,
                                                                                child: IconButton(
                                                                                  color: cardIcon,
                                                                                  iconSize: 50,
                                                                                  padding: EdgeInsets.zero,
                                                                                  constraints: BoxConstraints(),
                                                                                  icon:Icon(Icons.play_arrow_rounded),
                                                                                  onPressed: (){
                                                                                    showDialog(
                                                                                      context: context,
                                                                                      builder: (BuildContext context) => VideoPopup(url: exercise.data['video'], name: exercise.data['name']),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                flex:1,
                                                                                child: IconButton(
                                                                                  color: cardIcon,
                                                                                  iconSize: 36,
                                                                                  padding: EdgeInsets.zero,
                                                                                  constraints: BoxConstraints(),
                                                                                  icon:Icon(Icons.message),
                                                                                  onPressed: (){

                                                                                  },
                                                                                ),
                                                                              ),
                                                                              // Container(
                                                                              //   height: 62,
                                                                              //   color: Colors.blue,
                                                                              // ),
                                                                              // Container(
                                                                              //   height: 31,
                                                                              //   color: Colors.blue,
                                                                              // ),
                                                                            ]

                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ]
                                                            );
                                                          }
                                                          else{

                                                             return Center(child: CircularProgressIndicator());
                                                          }
                                                        }

                                                      // print(snapshot.data[0]);


                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        CardDropDown(
                                            display: _display[index],
                                            reps:"${snapshot.data[index]["reps"]}",
                                            weight:"${snapshot.data[index]["weight"]}",
                                            t_id:snapshot.data[index]["id"],
                                            e_id:snapshot.data[index]["exercise"],
                                            setSubmitAllowed:(bool value){
                                              widget.setSubmitAllowed(value);
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            );
                          }),
                    );




                  }else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
