import 'package:flutter/material.dart';
import 'package:xcell/pages/group/group_items.dart';
import 'package:xcell/theme/style.dart';

Widget groupCard(dynamic item, BuildContext context, int index) {
  return Padding(
    padding: index.isEven ? EdgeInsets.only(top:8, left: 8, right: 8)
        : EdgeInsets.only(top:8, right: 8),
    child: InkWell(
      onTap: () =>
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GroupPage(item, context)),
          ),
      child: Expanded(
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
                        child: Text("${item.name}",
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
    ),
  );
}