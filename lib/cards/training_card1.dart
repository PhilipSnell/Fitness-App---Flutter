import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xcell/api_connection/set_feedback.dart';
import 'package:xcell/common/loading_indicator.dart';
import 'package:xcell/database/exercise_database.dart';
import 'package:xcell/popups/EntryComment.dart';
import 'package:xcell/popups/video_popup.dart';
import 'package:xcell/theme/style.dart';

import 'card_dropdown.dart';

class TrainingCard1 extends StatefulWidget {

  final int exercise;
  final String reps;
  final String weight;
  final int sets;
  final int id;
  final String comment;

  const TrainingCard1({
    Key key,
    this.exercise,
    this.reps,
    this.weight,
    this.sets,
    this.id,
    this.comment
  }) : super(key: key);
  @override
  _TrainingCard1State createState() => _TrainingCard1State();
}

class _TrainingCard1State extends State<TrainingCard1> {

  final e_db = ExerciseDatabase.instance;

  @override
  void initState(){

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color:cardBack,
      margin: EdgeInsets.only(top:0,left:0,right:0,bottom:2),
      child: Container(
          // height: 108,
          child:Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(3,0,2,0),
                //leading: Icon(Icons.image, size: 90),
                title: FutureBuilder<Map<String,dynamic>>(
                    future: e_db.queryRow(widget.exercise),
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
                                  child: InkWell(
                                    onTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) => VideoPopup(url: exercise.data['video'], name: exercise.data['name']),
                                      );
                                    },
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
                                        child: InkWell(
                                          onTap: (){
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) => CommentPopup(comment: widget.comment, name: exercise.data['name'],t_id: widget.id),
                                            );
                                          },
                                          child: Container(
                                            color: background,
                                            padding: EdgeInsets.all(5),
                                            // height:31,
                                            child:Center(
                                              child: Text("${exercise.data["name"]}",
                                                  textAlign: TextAlign.center),
                                            ),
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
                                                Text(widget.reps,
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
                                                child: Text(widget.weight,
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
                                              Container(
                                                child: Text("${widget.sets}",
                                                  style: TextStyle(color: cardFeatureText),
                                                ),
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                flex: 15,
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

    );
  }
}

