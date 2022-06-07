import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:xcell/pages/linked_accounts/myfitnesspal/mfp_api.dart';

part 'mfp_status_event.dart';
part 'mfp_status_state.dart';

class MfpStatusBloc extends Bloc<MfpStatusEvent, MfpStatusState> {
  final MfpApi mfpApi;

  MfpStatusBloc({@required this.mfpApi})
      : assert(MfpApi != null),
        super();

  @override
  MfpStatusState get initialState => MfpConnectionUnintialized();

  @override
  Stream<MfpStatusState> mapEventToState(
    MfpStatusEvent event,
  ) async* {
    if (event is MfpAppStarted) {
      final bool disconnected = await mfpApi.checkConnection();

      if (disconnected) {
        yield MfpDisconnected();
      } else {
        yield MfpConnected();
      }
    }

    if (event is MfpConnectedEvent) {
      yield MfpConnectionLoading();

      yield MfpConnected();
    }

    if (event is MfpDisconnectedEvent) {
      yield MfpConnectionLoading();

      yield MfpDisconnected();
    }
  }
}
