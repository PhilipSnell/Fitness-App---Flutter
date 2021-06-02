import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:xcell/bloc/authentication_bloc.dart";
import 'package:xcell/cards/training_card.dart';
import 'package:xcell/database/training_database.dart';
import 'package:xcell/theme/style.dart';
import 'package:xcell/cards/card_dropdown.dart';
import 'package:xcell/api_connection/api_connection.dart';

class TrainPage extends StatefulWidget {
  const TrainPage({Key key}) : super(key: key);

  @override
  _TrainPageState createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> {
  bool submit_allowed =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TrainingCard(
        setSubmitAllowed:(bool value){
          setState(() {
            submit_allowed = value;
          });
        },
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
    );
  }
}
