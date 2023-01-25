import 'package:json_annotation/json_annotation.dart';

part 'nickname_list_by_phone_response.g.dart';

@JsonSerializable()
class NickNameListByPhoneResponse {
  final List<String> nicknames;
  final String answerNickName;

  const NickNameListByPhoneResponse({
    required this.nicknames,
    required this.answerNickName,
  });

  factory NickNameListByPhoneResponse.fromJson(Map<String, dynamic> json) => _$NickNameListByPhoneResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NickNameListByPhoneResponseToJson(this);
}