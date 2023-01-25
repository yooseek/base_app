import 'package:json_annotation/json_annotation.dart';
import 'package:withapp_did/data/wedid_data.dart';

part 'signup_response.g.dart';

@JsonSerializable()
class SignUpResponse {
  final TokenResponse token;
  final String nickName;

  const SignUpResponse({
    required this.token,
    required this.nickName,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) => _$SignUpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpResponseToJson(this);
}