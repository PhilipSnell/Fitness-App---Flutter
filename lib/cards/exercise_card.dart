import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xcell/common/loading_indicator.dart';
import 'package:xcell/popups/video_popup.dart';
import 'package:xcell/theme/style.dart';

import 'exercise_list.dart';

// final String baseUrl = "https://xcellfitness.herokuapp.com";

Widget exerciseCard(dynamic item, BuildContext context){
  return Padding(
    padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color:cardBack,
      child: Container(
        height: 114,
        child:Column(
          children: <Widget>[

            ListTile(
              contentPadding: EdgeInsets.fromLTRB(3,0,2,0),
              //leading: Icon(Icons.image, size: 90),
              title: Row(
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
                          child: CachedNetworkImage(
                            imageUrl:  "$baseUrl${item['image']}",
                            placeholder: (context, url) => new LoadingIndicator(),
                            errorWidget: (context, url, error) => new Icon(Icons.error),
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
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                color: background,
                                height:31,
                                child:Center(
                                  child: Text("${item['name']}",
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Container(
                              height:62,
                              child:Align(
                                alignment: Alignment.center,
                                child: Text("${item['description']}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: cardText),
                                ),
                              ),
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

                          child: IconButton(
                            color: cardIcon,
                            iconSize: 60
                            ,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon:Icon(Icons.play_arrow_rounded),
                            onPressed: (){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => VideoPopup(url: item['video'], name: item['name']),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ]
              ),
            ),
          ],
        ),
      ),
    ),
  );
}