import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:xcell/bloc/authentication_bloc.dart";
import 'package:xcell/cards/exercise_list.dart';
import 'package:xcell/database/training_database.dart';
import 'package:xcell/theme/style.dart';

Widget exercisePage(){

  return Scaffold(
    body: ExerciseList(),
  );
}
