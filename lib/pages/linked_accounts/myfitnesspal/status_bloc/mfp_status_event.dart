part of 'mfp_status_bloc.dart';

abstract class MfpStatusEvent extends Equatable {
  const MfpStatusEvent();

  @override
  List<Object> get props => [];
}

class MfpAppStarted extends MfpStatusEvent {}

class MfpConnectedEvent extends MfpStatusEvent {
  final String username;

  const MfpConnectedEvent({@required this.username});

  @override
  List<Object> get props => [username];

  @override
  String toString() => 'MfpConnectedEvent { user: ${username.toString()} }';
}

class MfpDisconnectedEvent extends MfpStatusEvent {
  const MfpDisconnectedEvent();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'MfpDisconnectedEvent }';
}
