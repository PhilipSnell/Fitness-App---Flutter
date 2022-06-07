import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:xcell/pages/linked_accounts/myfitnesspal/mfp_api.dart';
import 'package:xcell/pages/linked_accounts/myfitnesspal/status_bloc/mfp_status_bloc.dart';

part 'mfp_event.dart';
part 'mfp_state.dart';

class MfpBloc extends Bloc<MfpEvent, MfpState> {
  final MfpApi mfpApi;
  final MfpStatusBloc mfpStatusBloc;

  MfpBloc({
    @required this.mfpApi,
    @required this.mfpStatusBloc,
  }) : assert(mfpApi != null, mfpStatusBloc != null);

  @override
  MfpState get initialState => MfpInitial();

  @override
  Stream<MfpState> mapEventToState(
    MfpEvent event,
  ) async* {
    if (event is Connect) {
      yield ConnectLoading();
      try {
        bool status = await mfpApi.attemptMfpConnection(
          username: event.username,
          password: event.password,
        );
        mfpStatusBloc.add(MfpConnectedEvent(username: event.username));
        yield MfpInitial();
      } catch (error) {
        yield ConnectFailure(error: error.toString());
        mfpStatusBloc.add(MfpDisconnectedEvent());
      }
    }
    if (event is Disconnect) {
      yield ConnectLoading();
      try {
        bool status = await mfpApi.disconnectMfp();
        mfpStatusBloc.add(MfpDisconnectedEvent());
        yield MfpInitial();
      } catch (error) {
        yield DisconnectFailure(error: error.toString());
      }
    }
  }
}
