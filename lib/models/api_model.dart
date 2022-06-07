class UserLogin {
  String username;
  String password;

  UserLogin({this.username, this.password});

  Map <String, dynamic> toDatabaseJson() => {
    "username": this.username,
    "password": this.password
  };
}

class UserSignup {
  String username;
  String password;
  String email;
  String firstName;
  String lastName;

  UserSignup({this.username, this.password, this.email, this.firstName, this.lastName});

  Map <String, dynamic> toDatabaseJson() => {
    "username": this.username,
    "password": this.password,
    "email": this.email,
    "first_name": this.firstName,
    "last_name": this.lastName,
  };
}

class Token{
  String token;

  Token({this.token});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
        token: json['token']
    );
  }
}