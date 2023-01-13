part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
}

class Signup extends SignupEvent {
  const Signup();

  @override
  List<Object> get props => [];
}