part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
}

class SignupButtonPressed extends SignupEvent {
  final String username;
  final String password;
  final String email;
  final String firstName;
  final String lastName;

  const SignupButtonPressed({
    @required this.username,
    @required this.password,
    @required this.email,
    @required this.firstName,
    @required this.lastName,
  });
  @override
  List<Object> get props => [username, password, email, firstName, lastName];

  @override
  String toString() => 'SignupButtonPressed { username: $username, password: $password, email: $email }';
}
