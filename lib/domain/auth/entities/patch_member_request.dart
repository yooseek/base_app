import 'package:json_annotation/json_annotation.dart';

part 'patch_member_request.g.dart';

@JsonSerializable()
class PatchMemberRequest {
  final String nickname;

  const PatchMemberRequest({
    required this.nickname,
  });

  factory PatchMemberRequest.fromJson(Map<String, dynamic> json) => _$PatchMemberRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PatchMemberRequestToJson(this);
}