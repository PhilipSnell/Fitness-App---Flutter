import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xcell/common_widgets/loading_indicator.dart';
import 'package:xcell/database/exercise_database.dart';
import 'package:xcell/pages/training/popups/entry_comment.dart';
import 'package:xcell/pages/training/popups/video_popup.dart';
import 'package:xcell/theme/style.dart';

class TrainingCard extends StatefulWidget {
  final int exercise;
  final String reps;
  final String weight;
  final int sets;
  final int id;
  final String comment;
  final Function(bool) setSubmitAllowed;

  const TrainingCard(
      {Key key,
      this.exercise,
      this.reps,
      this.weight,
      this.sets,
      this.id,
      this.comment,
      this.setSubmitAllowed})
      : super(key: key);
  @override
  _TrainingCardState createState() => _TrainingCardState();
}

class _TrainingCardState extends State<TrainingCard> {
  final e_db = ExerciseDatabase.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: cardBack,
      margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 2),
      child: Container(
        // height: 108,
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(3, 0, 2, 0),
              //leading: Icon(Icons.image, size: 90),
              title: FutureBuilder<Map<String, dynamic>>(
                  future: e_db.queryRow(widget.exercise),
                  builder: (BuildContext context, AsyncSnapshot exercise) {
                    if (exercise.hasData) {
                      return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 90,
                                width: 90,
                                color: cardBack,
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          VideoPopup(
                                              url: exercise.data['video'],
                                              name: exercise.data['name']),
                                    );
                                  },
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Container(
                                        height: 90,
                                        width: 90,
                                        child: Center(
                                          child: ClipRect(
                                            child: Align(
                                              widthFactor: 1,
                                              child: OverflowBox(
                                                maxWidth: 180,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "${exercise.data["image"]}",
                                                  placeholder: (context, url) =>
                                                      new LoadingIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                  filterQuality:
                                                      FilterQuality.high,
                                                  width: 170,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
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
                                  // -----------------------------------------------------
                                  // Exercise Name
                                  // -----------------------------------------------------
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CommentPopup(
                                              comment: widget.comment,
                                              name: exercise.data['name'],
                                              t_id: widget.id,
                                              setSubmitAllowed: (bool value) {
                                                setState(() {
                                                  widget
                                                      .setSubmitAllowed(value);
                                                });
                                              },
                                            ),
                                          );
                                        },
                                        child: Container(
                                          color: background,
                                          height: 30,
                                          padding:
                                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: 20,
                                                width: 20,
                                              ),
                                              Text(
                                                "${exercise.data["name"]}",
                                                textAlign: TextAlign.center,
                                                style:
                                                    TextStyle(color: cardIcon),
                                              ),
                                              Icon(
                                                Icons.comment,
                                                color: cardIcon,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    height: 62,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                "reps",
                                                style:
                                                    TextStyle(color: cardText),
                                              ),
                                              Text(
                                                widget.reps,
                                                style: TextStyle(
                                                    color: cardFeatureText),
                                              ),
                                            ]),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "weight",
                                              style: TextStyle(color: cardText),
                                            ),
                                            Container(
                                              child: Text(
                                                widget.weight,
                                                style: TextStyle(
                                                    color: cardFeatureText),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "sets",
                                              style: TextStyle(color: cardText),
                                            ),
                                            Container(
                                              child: Text(
                                                "${widget.sets}",
                                                style: TextStyle(
                                                    color: cardFeatureText),
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
                          ]);
                    } else {
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
