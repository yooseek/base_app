part of 'signin_bloc.dart';

class SignInState extends Equatable {
  final String? phoneNumber;
  final String? certNumber;
  final SignInProcess process;
  final SignInError error;
  final SignInNetwork network;

  const SignInState({
    this.phoneNumber,
    this.certNumber,
    required this.process,
    required this.error,
    required this.network,
  });

  factory SignInState.init() {
    return const SignInState(process: SignInProcess.phoneNum,network: SignInNetwork.init,error: SignInError.noError);
  }

  SignInState copyWith({
    String? phoneNumber,
    String? certNumber,
    SignInProcess? process,
    SignInError? error,
    SignInNetwork? network,
  }) {
    return SignInState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      certNumber: certNumber ?? this.certNumber,
      process: process ?? this.process,
      error: error ?? this.error,
      network: network ?? this.network,
    );
  }

  @override
  List<Object?> get props => [phoneNumber, certNumber, process, error, network,];
}

enum SignInProcess {
  phoneNum,
  verifyPhoneNum,
}

enum SignInNetwork {
  init,
  loading,
  loaded,
}

enum SignInError {
  inValidPhoneNumber,
  notMatchCertNumber,
  inValidCertNumber,
  expiredCertNumber,
  notExistCertNumber,
  notExistUser,
  networkError,
  noError,
  done,
}
