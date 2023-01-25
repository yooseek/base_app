part of 'signup_bloc.dart';

class SignupState extends Equatable {
  final String? name;
  final String? birth;
  final Gender? gender;
  final String? phoneNumber;
  final String? nickName;
  final SignUpProcess process;
  final SignUpError error;
  final SignUpNetwork network;

  const SignupState({
    this.name,
    this.birth,
    this.gender,
    this.phoneNumber,
    this.nickName,
    required this.process,
    required this.error,
    required this.network,
  });

  factory SignupState.init(){
    return const SignupState(process: SignUpProcess.name,
        error: SignUpError.noError,
        network: SignUpNetwork.init);
  }

  SignupState copyWith({
    String? name,
    String? birth,
    Gender? gender,
    String? phoneNumber,
    String? nickName,
    SignUpProcess? process,
    SignUpError? error,
    SignUpNetwork? network,
  }) {
    return SignupState(
      name: name ?? this.name,
      birth: birth ?? this.birth,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nickName: nickName ?? this.nickName,
      process: process ?? this.process,
      error: error ?? this.error,
      network: network ?? this.network,
    );
  }

  @override
  List<Object?> get props => [name, birth, gender, phoneNumber, nickName, process, error, network,];
}

enum SignUpProcess {
  name,
  birth,
  gender,
  phoneNum,
  verifyPhoneNum,
  welcome,
}

enum SignUpError {
  emptyName,
  wrongBirth,
  emptyGender,
  inValidPhoneNumber,
  notMatchCertNumber,
  inValidCertNumber,
  expiredCertNumber,
  notExistCertNumber,
  existUser,
  networkError,
  noError,
}

enum SignUpNetwork {
  init,
  loading,
  loaded,
}