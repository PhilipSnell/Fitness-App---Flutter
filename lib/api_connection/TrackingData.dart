import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xcell/api_connection/api_connection.dart';
import 'package:xcell/database/tracking_data.dart';
import 'package:xcell/models/group.dart';
import 'package:xcell/repository/user_repository.dart';

final _group = "/groups/";
final _tracking = "/trackingValsUpdate/";

final _trackingURL = Uri.parse(APIglobs.base + APIglobs.api +_tracking);
final _groupURL = Uri.parse(APIglobs.base + APIglobs.api + _group);

Future<List> getGroupData() async {

  print(_groupURL);
  String email = await UserRepository().getUsername();
  email = email.replaceAll(' ', '');
  var request = {};
  print("---------------------------------------");
  print(email);
  request["username"] = email;
  String post = json.encode(request);

  print(post);
  final http.Response response = await http.post(
    _groupURL,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: post,
  );
  List<Group> groups = [];
  for (final entry in json.decode(response.body) ){
    List<TextField> textfields = [];
    for (final field in entry["textfields"]){
      TextField textfield = TextField(
        id: field["id"],
        name: field["name"],
        type: field["type"],
      );
      textfields.add(textfield);
    }

    Group group = Group(
      id: entry["id"],
      name: entry["name"],
      textfields: textfields,
    );
    groups.add(group);
  }
  return groups;
}

Future<bool> syncTrackingDataAPI(var item, DateTime day) async {
  final tracking_db = TrackingDatabase.instance;
  var field_ids = [];
  String email = await UserRepository().getUsername();
  email = email.replaceAll(' ', '');
  for (final textfield in item.textfields) {
    field_ids.add(textfield.id);
  }
  List<TextValue> tmp_list = await tracking_db.queryID(field_ids,day);

  List<Map<String, dynamic>> postData = [];
  for (final item in tmp_list){
    postData.add(item.toJson());
  }
  var request = {};
  request['client'] = email;
  request['textVals'] = postData;
  String post = json.encode(request);
  print(post);
  final http.Response response = await http.post(
    _trackingURL,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: post,
  );
  print(response);
  if (response.statusCode == 200) {
    return true;
  } else {
    print(json.decode(response.body).toString());
    return false;
  }
  return false;
}