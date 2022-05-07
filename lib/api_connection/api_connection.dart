import 'dart:async';
import 'dart:convert';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:xcell/database/exercise_database.dart';
import 'package:xcell/database/set_database.dart';
import 'package:xcell/database/training_database.dart';
import 'package:xcell/model/api_model.dart';
import 'package:xcell/models/exercise.dart';
import 'package:xcell/models/group.dart';
import 'package:xcell/models/training_set.dart';
import 'package:xcell/repository/user_repository.dart';
import 'package:xcell/models/training_entry.dart';
import 'package:xcell/models/exercise.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class APIglobs {
  static var api = "/api";
  static var base = "https://xcellfitness.herokuapp.com";
}
final _set = "/sets/";
final _email = "/data/";
final _check = "/checkupdates/";
final _exer = "/exercise/";
final _chat = "/loadmessages/";
final _send = "/messages/";
final _tokenEndpoint = "/api-token-auth/";
final _register = "/register/";
final _group = "/groups/";
final Uri _groupURL = Uri.parse(APIglobs.base + APIglobs.api + _group);
final _chatURL = Uri.parse(APIglobs.base + APIglobs.api + _chat);
final _setURL = Uri.parse(APIglobs.base + APIglobs.api + _set);
final _sendMessageURL = Uri.parse(APIglobs.base + APIglobs.api + _send);
final _emailURL = Uri.parse(APIglobs.base + APIglobs.api + _email);
final _checkURL = Uri.parse(APIglobs.base + APIglobs.api + _check);
final _exerURL = Uri.parse(APIglobs.base + APIglobs.api + _exer);
final _tokenURL = Uri.parse(APIglobs.base + APIglobs.api + _tokenEndpoint);
final _registerURL = Uri.parse(APIglobs.base + APIglobs.api + _register);

final defaultImage = APIglobs.base + "/media/images/pullup_wbq2Kcf.png";
  final utubeThumbnailBase = "https://img.youtube.com/vi/";

// void sendMessage(types.TextMessage textMessage) async {
//
//   // print(_sendMessageURL);
//   // String email = await UserRepository().getUsername();
//
//   // print("---------------------------------------");
//   // print(email);
//   var request = {};
//   request["sender"] = 1;
//   request["receiver"] = 2;
//   request["message"] = textMessage.text;
//   // String timestamp = "${DateTime.fromMillisecondsSinceEpoch(textMessage.timestamp*1000)}";
//   // timestamp = timestamp.replaceAll(" ","T");
//   // timestamp = "${timestamp}000Z";
//   // request["timestamp"] = timestamp;
//   // print(request);
//   String post = json.encode(request);
//
//   // print(post);
//   final http.Response response = await http.post(
//     _sendMessageURL,
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: post,
//   );
//   // print(response.body);
// }

// Future<List<types.TextMessage>> getChatData() async {
//
//   // print(_chatURL);
//   String email = await UserRepository().getUsername();
//   var request = {};
//   // print("---------------------------------------");
//   // print(email);
//   request["username"] = email;
//   String post = json.encode(request);
//
//   // print(post);
//   final http.Response response = await http.post(
//     _chatURL,
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: post,
//   );
//   // List<types.TextMessage> messages=[];
//   for(final entry in json.decode(response.body)){
//     String time = entry["timestamp"].replaceAll("T", " ");
//     if (time != null && time.length > 0) {
//       time = time.substring(0, time.length - 1);
//     }
//     // final textMessage = types.TextMessage(
//     //   authorId: entry["sender"] == 1 ? "0" : "1",
//     //   // authorId: "${entry["sender"]}",
//     //   id: "0",
//     //
//     //   text: entry["message"],
//     //   timestamp: (DateTime.parse(time).millisecondsSinceEpoch / 1000).floor(),
//     // );
//     // messages.add(textMessage);
//     //print(DateTime.parse(time).millisecondsSinceEpoch);
//   }
//   //print(DateTime.now().millisecondsSinceEpoch);
//   // return messages;
//   return null;
// }
//



class trainingApiProvider {
  final db = DatabaseHelper.instance;
  final e_db = ExerciseDatabase.instance;
  void getTrainingData() async {

    // print(_emailURL);
    String email = await UserRepository().getUsername();
    email = email.replaceAll(' ','');
    var request = {};
    // print("---------------------------------------");
    // print(email);
    request["username"] = email;
    String post = json.encode(request);
    // print(post);
    final http.Response checkUpdate = await http.post(
      _checkURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: post,
    );
    print(json.decode(checkUpdate.body)['update']);
    if (!json.decode(checkUpdate.body)['update']) return;
    final http.Response response = await http.post(
      _emailURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: post,
    );

    print("deleting training db");
    await DatabaseHelper.deleteAll();
    for(final entry in json.decode(response.body)){
      print(entry);
      var exercise = entry['exercise'];
      print(exercise);
      if (exercise["image"] == null){
        try {
          int len =exercise["video"].toString().length;
          String utubeID = exercise["video"].substring(len-11, len);
          exercise["image"] = utubeThumbnailBase + utubeID + "/0.jpg";
          print(exercise['image']);
        }
        catch(e){
          exercise["image"] = defaultImage;
        }
      }
      else{
        exercise["image"] = APIglobs.base + exercise["image"];
      }
      Exercise exer = Exercise.fromJson(exercise);
      Map<String, dynamic> entry2 = exer.toJson();
      var result1 = await e_db.insert(entry2);
      if(result1==null){
        // print("Exercise already existed ... updating");
        await e_db.update(entry2);
      }
      TrainingEntry item = TrainingEntry.fromJson(entry);
      Map<String, dynamic> entry1 = item.toJson();

      print('inserting $entry1');

      var result = await db.insert(entry1);
      if(result==null){
        print("Entry already existed");
      }
      else{
        print("Successfully added $entry1");
      }
    }
  }
  void getExerciseData() async {

    // print(_exerURL);
    String email = await UserRepository().getUsername();
    var request = {};
    // print("---------------------------------------");
    // print(email);
    request["username"] = email;
    String post = json.encode(request);
    // print(post);
    final http.Response response = await http.post(
      _exerURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: post,
    );
    // await e_db.deleteAll();
    for(final entry in json.decode(response.body)){
      if (entry["image"] == null){
        try {
          int len =entry["video"].toString().length;
          String utubeID = entry["video"].substring(len-11, len);
          entry["image"] = utubeThumbnailBase + utubeID + "/0.jpg";
        }
        catch(e){
          entry["image"] = defaultImage;
        }
      }
      else{
        entry["image"] = APIglobs.base + entry["image"];
      }
      Exercise exer = Exercise.fromJson(entry);
      Map<String, dynamic> entry2 = exer.toJson();
      var result1 = await e_db.insert(entry2);
      if(result1==null){
        // print("Exercise already existed ... updating");
        await e_db.update(entry2);
      }
      else{
        // print("Successfully added $entry2");
      }
    }
  }
}

Future<bool> syncSetData() async {
  final set_db = SetDatabase.instance;
  // sends all set data - need to reduce it to only send specific day data
  List<Map<String, dynamic>> setData = await set_db.queryAllRows();
  List<Map<String, dynamic>> postData = [];
  for (final item in setData){

    TrainingSet set = TrainingSet.fromJson(item);
    if (set.comment == null){
      set.comment = '';
    }
    if (set.sets == -1){
      set.reps = "-1";
      set.weights = "-1";
    }
    postData.add(set.toJson());
  }
  //print("set Data: $setData");
    print("post Data: ${json.encode(postData)}");
  final http.Response response = await http.post(
    _setURL,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(postData),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    // print(json.decode(response.body).toString());
    return false;
  }
}

Future<Token> getToken(UserLogin userLogin) async {
  // print(_tokenURL);
  final http.Response response = await http.post(
    _tokenURL,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userLogin.toDatabaseJson()),
  );
  if (response.statusCode == 200) {
    return Token.fromJson(json.decode(response.body));
  } else {
    // print(json.decode(response.body).toString());
    throw Exception(json.decode(response.body));
  }
}

Future<bool> createUser(UserSignup userSignup) async {
  // print(_registerURL);
  final http.Response response = await http.post(
    _registerURL,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userSignup.toDatabaseJson()),
  );
  if (response.statusCode == 200) {
    Map<String, Object> data = json.decode(response.body);
    if (data.containsKey("response")){
      return true;
    }
    else{
      // print(data);
      throw Exception(data);
    }
    return true;
  } else {
    // print(json.decode(response.body).toString());
    throw Exception(json.decode(response.body));
  }
}
