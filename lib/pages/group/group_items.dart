import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xcell/models/group.dart';
import 'package:xcell/theme/style.dart';

Widget GroupPage(dynamic item, BuildContext context){
  return Scaffold(
    appBar: AppBar(
        backgroundColor: background,
        centerTitle: true,
        title: Text('${item.name}')
    ),
    body: GridView.count(

      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 1,
      childAspectRatio: (6 / 1),
      // Generate 100 widgets that display their index in the List.
      children: List.generate(item.textfields.length +item.intfields.length, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 30,
              color: cardBack,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left:15),
                      child: index<item.textfields.length
                          ? Text("${item.textfields[index].name}",
                              style: TextStyle(
                                color: cardText,
                                fontSize: 18,
                              ))
                          : Text("${item.intfields[index-item.textfields.length].name}",
                              style: TextStyle(
                                  color: cardText,
                                fontSize: 18,
                              )),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              color: groupItemInput,
                              child: index<item.textfields.length
                                  ? TextFormField(
                                      //
                                      textAlign: TextAlign.center,
                                      onChanged: (text) {

                                      },
                              )
                                  : TextFormField(
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ],
                                      // decoration: InputDecoration(
                                      //   labelText: "whatever you want",
                                      //   hintText: "whatever you want",
                                      //   icon: Icon(Icons.phone_iphone)
                                      // ),
                                      onChanged: (text) {

                                      },
                              ),
                            ),
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
        );
      }),
    ),
  );
}