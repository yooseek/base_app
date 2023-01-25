part of 'signup_bloc.dart';

abstract class SignupEvent {
  const SignupEvent();
}
class SignUpInitEvent extends SignupEvent {}

class SetNameEvent extends SignupEvent {
  final String name;

  const SetNameEvent({required this.name});
}

class SetBirthEvent extends SignupEvent {
  final String birth;

  const SetBirthEvent({required this.birth});
}

class SetGenderEvent extends SignupEvent {
  final Gender? gender;
  final bool nextStep;

  const SetGenderEvent({this.gender,this.nextStep = false});
}

class SetPhoneNumberEvent extends SignupEvent {
  final String phoneNumber;

  const SetPhoneNumberEvent({required this.phoneNumber});
}

class SetCertNumberEvent extends SignupEvent {
  final String certNumber;

  const SetCertNumberEvent({required this.certNumber});
}

class ChangeProcessEvent extends SignupEvent {
  final SignUpProcess process;

  const ChangeProcessEvent({required this.process});
}