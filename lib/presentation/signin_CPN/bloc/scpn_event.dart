part of 'scpn_bloc.dart';

abstract class SCPNEvent {
  const SCPNEvent();
}

class SetSCPNPhoneNumEvent extends SCPNEvent {
  final String phoneNumber;

  const SetSCPNPhoneNumEvent({required this.phoneNumber});
}

class MatchNickNameEvent extends SCPNEvent {
  final String nickname;

  const MatchNickNameEvent({required this.nickname});
}

class ChangePhoneNumEvent extends SCPNEvent {
  final String phoneNumber;

  const ChangePhoneNumEvent({required this.phoneNumber});
}

class ChangeSCPNSProcessEvent extends SCPNEvent {
  final SCPNProcess process;

  const ChangeSCPNSProcessEvent({required this.process});
}