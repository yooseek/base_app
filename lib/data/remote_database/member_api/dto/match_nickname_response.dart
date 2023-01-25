import 'package:json_annotation/json_annotation.dart';

part 'match_nickname_response.g.dart';

@JsonSerializable()
class MatchNickNameResponse {
  final int tryCount;
  final bool isSuccess;

  const MatchNickNameResponse({
    required this.tryCount,
    required this.isSuccess,
  });

  factory MatchNickNameResponse.fromJson(Map<String, dynamic> json) => _$MatchNickNameResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MatchNickNameResponseToJson(this);
}