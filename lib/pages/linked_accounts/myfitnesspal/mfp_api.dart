import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:xcell/api_connection/api_connection.dart';
import 'package:xcell/repository/user_repository.dart';

final _connect = "/syncmfp/";
final _connectURL = Uri.parse(APIglobs.base + APIglobs.api + _connect);

class MfpApi {
  Future<bool> attemptMfpConnection(
      {@required String username, @required String password}) async {
    bool status = await connectMFP(username, password);
    return status;
  }

  Future<bool> checkConnection() async {
    bool status = await checkMFP();
    return status;
  }

  Future<bool> disconnectMfp() async {
    bool status = await disconnectMFP();
    return status;
  }
}

Future<bool> connectMFP(String username, String password) async {
  String email = await UserRepository().getUsername();
  email = email.replaceAll(' ', '');
  var request = {};
  request["username"] = email;
  request["mfp-username"] = username;
  request["password"] = password;
  String post = json.encode(request);
  final http.Response response = await http.post(
    _connectURL,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: post,
  );
  print(json.decode(response.body));
  if (response.statusCode == 200) {
    final status = json.decode(response.body)['sync_complete'];
    if (status == true) {
      return status;
    } else {
      throw Exception("Incorrect login details for MyFitnessPal");
    }
  } else {
    throw Exception(json.decode(response.body));
  }
}

Future<bool> checkMFP() async {
  String email = await UserRepository().getUsername();
  email = email.replaceAll(' ', '');
  var request = {};
  request["username"] = email;
  String patch = json.encode(request);
  final http.Response response = await http.patch(
    _connectURL,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: patch,
  );

  if (response.statusCode == 200) {
    final status = json.decode(response.body)['sync_required'];
    return status;
  } else {
    throw Exception(json.decode(response.body));
  }
}

Future<bool> disconnectMFP() async {
  String email = await UserRepository().getUsername();
  email = email.replaceAll(' ', '');
  var request = {};
  request["username"] = email;
  String delete = json.encode(request);
  final http.Response response = await http.delete(
    _connectURL,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: delete,
  );
  final status = json.decode(response.body)['disconnected'];
  if (status == true) {
    return status;
  } else {
    throw Exception(json.decode(response.body));
  }
}
