import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:xcell/bloc/authentication_bloc.dart';
import 'package:xcell/common/loading_indicator.dart';
import 'package:xcell/repository/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final UserRepository userRepository;

  SignupBloc({
    @required this.userRepository,
  })  : assert(userRepository != null);


  @override
  SignupState get initialState => SignupInitial();

  @override
  Stream<SignupState> mapEventToState(
      SignupEvent event,
      ) async* {
    if (event is SignupButtonPressed) {
      yield SignupLoading();
      try {
        await userRepository.signUp(
          username: event.username,
          password: event.password,
          email: event.email,
          firstName: event.firstName,
          lastName: event.lastName,
        );
        yield SignupSuccess();
      } catch (error) {
        yield SignupFailure(error: error.toString());
      }
    }
  }
}