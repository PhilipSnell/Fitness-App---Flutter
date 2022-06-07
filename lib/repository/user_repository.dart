import 'dart:async';
import 'package:xcell/models/user_model.dart';
import 'package:meta/meta.dart';
import 'package:xcell/models/api_model.dart';
import 'package:xcell/api_connection/api_connection.dart';
import 'package:xcell/dao/user_dao.dart';

class UserRepository {
  final userDao = UserDao();

  Future<User> authenticate ({
    @required String email,
    @required String password,
  }) async {
    UserLogin userLogin = UserLogin(
        username: email,
        password: password
    );
    Token token = await getToken(userLogin);
    User user = User(
      id: 0,
      username: email,
      token: token.token,
    );
    return user;
  }

  Future<bool> signUp ({
    bool success,
    @required String username,
    @required String password,
    @required String email,
    @required String firstName,
    @required String lastName,
  }) async {
    UserSignup userSignup = UserSignup(
        username: username,
        password: password,
        email: email,
        firstName: firstName,
        lastName: lastName,
    );
    success = await createUser(userSignup);

    return success;
  }

  Future<void> persistToken ({
    @required User user
  }) async {
    // write token with the user to the database
    await userDao.createUser(user);
  }

  Future <void> deleteToken({
    @required int id
  }) async {
    await userDao.deleteUser(id);
  }

  Future <bool> hasToken() async {
    bool result = await userDao.checkUser(0);
    return result;
  }
  Future <String> getUsername() async {
    String result = await userDao.getUsername(0);
    return result;
  }
}