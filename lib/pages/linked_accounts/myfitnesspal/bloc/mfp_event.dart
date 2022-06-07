part of 'mfp_bloc.dart';

abstract class MfpEvent extends Equatable {
  const MfpEvent();
}

class Connect extends MfpEvent {
  final String username;
  final String password;

  const Connect({@required this.username, @required this.password});
  @override
  List<Object> get props => [username, password];

  @override
  String toString() => 'Connect { username: $username, password: $password }';
}

class Disconnect extends MfpEvent {
  const Disconnect();
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Disconnected myfitnesspal';
}
