part of 'signin_bloc.dart';

abstract class SigninEvent extends Equatable {
  const SigninEvent();
}

class GetCertNumber extends SigninEvent {
  final String phoneNumber;
  const GetCertNumber({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class VerifyPhoneCert extends SigninEvent {
  final String certNumber;
  const VerifyPhoneCert({required this.certNumber});

  @override
  List<Object> get props => [certNumber];
}