import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:xcell/bloc/authentication_bloc.dart";
import 'package:xcell/cards/training_card.dart';
import 'package:xcell/theme/style.dart';

Widget reportPage(){
  return Scaffold(
    body: Container(

      color: background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              'Report Page',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
