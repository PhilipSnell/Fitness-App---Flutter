import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xcell/api_connection/api_connection.dart';
import 'package:xcell/database/tracking_data.dart';
import 'package:xcell/models/group.dart';
import 'package:xcell/repository/user_repository.dart';

final _get = "/getfeedback/";
final _set = "/setfeedback/";

final _getURL = APIglobs.base + APIglobs.api +_get;
final _setURL = APIglobs.base + APIglobs.api + _set;

Future<List> getSetFeedback(int t_id) async {

  print(_getURL);

  var request = {};

  request["t_id"] = "$t_id";
  String post = json.encode(request);
  final http.Response response = await http.post(
    _getURL,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: post,
  );
  var data = json.decode(response.body);
  return [data['feedback'], data["difficulty"]];
}
void SetFeedback(int t_id, String feedback) async {

  print(_setURL);

  var request = {};

  request["t_id"] = "$t_id";
  request["feedback"] = feedback;
  request["difficulty"] = "";
  String post = json.encode(request);
  print(post);
  final http.Response response = await http.post(
    _setURL,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: post,
  );
  print(json.decode(response.body));
  return ;
}
void SetDifficulty(int t_id, int difficulty) async {

  print(_setURL);

  var request = {};

  request["t_id"] = "$t_id";
  request["feedback"] = "dif";
  request["difficulty"] = difficulty;
  String post = json.encode(request);
  print(post);
  final http.Response response = await http.post(
    _setURL,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: post,
  );
  print(json.decode(response.body));
  return ;
}
