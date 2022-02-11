import 'dart:core';

import 'package:flutter/material.dart';
import 'package:xcell/api_connection/TrackingData.dart';
import 'package:xcell/pages/group/group_items.dart';
import 'package:xcell/theme/style.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../database/tracking_data.dart';

class groupCard extends StatefulWidget {
  final dynamic item;
  final DateTime day;
  final completion;
  final int index;
  const groupCard({
    Key key,
    this.item,
    this.completion,
    this.day,
    this.index
  }) : super(key: key);

  @override
  _groupCardState createState() => _groupCardState();
}

class _groupCardState extends State<groupCard> {
  final tracking_db = TrackingDatabase.instance;
  var _ids;
  var _vals;
  var _day;
  bool syncTracking =false;
  var _completion;
  Future<Null> getCompletion() async{
    var completion ;
    List ids = [];
    List vals = [];
    List textvals;
    ids = [];
    for (final field in widget.item.textfields) {
      ids.add(field.id);
    }
    textvals = await tracking_db.queryID(ids, _day);
    vals = [];
    for (final textval in textvals){
      if (textval.value != ""){
        vals.add(textval.value);
      }

    }
    if(ids.length != 0){

      completion = vals.length/ids.length;

    }


    setState(() {
      _ids=ids;
      _vals=vals;
      _completion=double.parse((completion).toStringAsFixed(1));
    });

  }
  @override
  void initState() {
    getCompletion();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    getCompletion();
    _day =widget.day;
    return Padding(
      padding: widget.index.isEven ? EdgeInsets.only(top:8, left: 8, right: 8)
          : EdgeInsets.only(top:8, right: 8),
      child: InkWell(
        onTap: () =>
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => groupPage(
                  valueChanged:(bool value){
                    setState(() {
                      syncTracking = value;
                    });
                  },
                  item: widget.item,
                  day: _day,
                ))
            ).then(
                  (context){
                syncTrackingData(widget.item,_day);
              },
            ),
        child: ClipRRect(

          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: cardBack,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      color: background,
                      height:35,
                      child:Center(
                        child: Text("${widget.item.name}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: groupCardTitle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 10.0,
                    percent: _completion,
                    progressColor:  _completion == 1
                    ? completedLogging
                    : featureColor,
                    center: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height:60,
                        width: 60,
                        color: groupDivider,
                        child: Stack(
                          children: [
                            ClipPath(
                              child: Container(
                                height: 60,

                                padding: const EdgeInsets.fromLTRB(6,6,0,0),
                                width: MediaQuery.of(context).size.width,
                                color: cardBack,

                                child: Text(
                                    "${_vals.length}",
                                  style: TextStyle(
                                    fontFamily: 'Syncopate',
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                              clipper: CustomClipPath(),
                            ),
                            ClipPath(
                              child: Container(
                                height: 60,
                                padding: const EdgeInsets.fromLTRB(35,35,0,0),
                                width: MediaQuery.of(context).size.width,
                                color: cardBack,
                                child: Text(
                                  "${_ids.length}",
                                  style: TextStyle(
                                    fontFamily: 'Syncopate',
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                              clipper: CustomClipPath2(),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void syncTrackingData(item, DateTime day) {
    getCompletion();
    if(syncTracking){
      syncTracking = false;
      syncTrackingDataAPI(item, day);
      print("-----------------------should sync -------------------------");


    }
    else {
      print("----------------------- dont sync -------------------------");
    }
  }
}
class CustomClipPath extends CustomClipper<Path> {
  var radius=10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(-1, -1);
    path.lineTo(-1,55);
    path.lineTo(55,-1);

    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
class CustomClipPath2 extends CustomClipper<Path> {
  var radius=10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(60, 60);
    path.lineTo(60,60);
    path.lineTo(5,60);
    path.lineTo(60,5);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}



