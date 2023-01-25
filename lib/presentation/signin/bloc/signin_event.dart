part of 'signin_bloc.dart';

abstract class SignInEvent{
  const SignInEvent();
}

class SetCertNumEvent extends SignInEvent {
  final String certNumber;

  const SetCertNumEvent({required this.certNumber});
}

class SetPhoneNumEvent extends SignInEvent {
  final String phoneNumber;

  const SetPhoneNumEvent({required this.phoneNumber});
}

class ChangeSignInProcessEvent extends SignInEvent {
  final SignInProcess process;

  const ChangeSignInProcessEvent({required this.process});
}