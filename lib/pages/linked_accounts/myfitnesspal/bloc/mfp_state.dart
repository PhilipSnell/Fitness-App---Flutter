part of 'mfp_bloc.dart';

abstract class MfpState extends Equatable {
  const MfpState();

  @override
  List<Object> get props => [];
}

class MfpInitial extends MfpState {}

class ConnectLoading extends MfpState {}

class ConnectFailure extends MfpState {
  final String error;

  const ConnectFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => ' ConnectFailure { error: $error }';
}

class DisconnectFailure extends MfpState {
  final String error;

  const DisconnectFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => ' DisconnectFailure { error: $error }';
}
