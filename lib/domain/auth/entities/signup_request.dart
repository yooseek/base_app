import 'package:json_annotation/json_annotation.dart';

import 'package:withapp_did/core/wedid_core.dart';

part 'signup_request.g.dart';

@JsonSerializable()
class SignUpRequest {
  final String realName;
  final String birthDay;
  final Gender gender;
  final String phoneNumber;

  const SignUpRequest({
    required this.realName,
    required this.birthDay,
    required this.gender,
    required this.phoneNumber,
  });

  factory SignUpRequest.fromJson(Map<String, dynamic> json) => _$SignUpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestToJson(this);
}