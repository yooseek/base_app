part of 'scpn_bloc.dart';

class SCPNState extends Equatable {
  final String? phoneNumber;
  final List<String>? nickNames;
  final List<bool>? isBlurNickNames;
  final String? nickname;
  final SCPNProcess process;
  final SCPNError error;
  final SCPNNetwork network;

  const SCPNState({
    this.phoneNumber,
    this.nickNames,
    this.isBlurNickNames,
    this.nickname,
    required this.process,
    required this.error,
    required this.network,
  });

  factory SCPNState.init(){
    return const SCPNState(
      process: SCPNProcess.phoneNum,
      error: SCPNError.noError,
      network: SCPNNetwork.init,
    );
  }

  SCPNState copyWith({
    String? phoneNumber,
    List<String>? nickNames,
    List<bool>? isBlurNickNames,
    String? nickname,
    SCPNProcess? process,
    SCPNError? error,
    SCPNNetwork? network,
  }) {
    return SCPNState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nickNames: nickNames ?? this.nickNames,
      isBlurNickNames: isBlurNickNames ?? this.isBlurNickNames,
      nickname: nickname ?? this.nickname,
      process: process ?? this.process,
      error: error ?? this.error,
      network: network ?? this.network,
    );
  }

  @override
  List<Object?> get props =>
      [
        phoneNumber,
        nickNames,
        isBlurNickNames,
        nickname,
        process,
        error,
        network,
      ];
}

enum SCPNProcess {
  phoneNum,
  matchNickName,
  changePhoneNum
}

enum SCPNNetwork {
  init,
  loading,
  loaded,
}

enum SCPNError {
  inValidPhoneNum,
  notExistUser,
  tooManyUnMatched,
  networkError,
  noError,
  done,
}
