part of 'mfp_status_bloc.dart';

abstract class MfpStatusState extends Equatable {
  const MfpStatusState();

  @override
  List<Object> get props => [];
}

class MfpStatusInitial extends MfpStatusState {}

class MfpConnectionUnintialized extends MfpStatusState {}

class MfpConnected extends MfpStatusState {}

class MfpDisconnected extends MfpStatusState {}

class MfpConnectionLoading extends MfpStatusState {}
