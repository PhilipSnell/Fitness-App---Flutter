import 'dart:core';

import 'package:flutter/material.dart';
import 'package:xcell/api_connection/TrackingData.dart';
import 'package:xcell/pages/group/group_items.dart';
import 'package:xcell/theme/style.dart';

class groupCard extends StatefulWidget {
  final dynamic item;
  final DateTime day;
  final int index;
  const groupCard({
    Key key,
    this.item,
    this.day,
    this.index
  }) : super(key: key);

  @override
  _groupCardState createState() => _groupCardState();
}

class _groupCardState extends State<groupCard> {
  bool syncTracking =false;
  @override
  Widget build(BuildContext context) {
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
                  day: widget.day,
                ))
            ).then(
                  (context){
                syncTrackingData(widget.item,widget.day);
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
              ],
            ),
          ),
        ),
      ),
    );
  }
  void syncTrackingData(item, DateTime day) {
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



