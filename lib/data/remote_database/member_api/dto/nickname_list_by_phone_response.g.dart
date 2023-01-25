// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nickname_list_by_phone_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NickNameListByPhoneResponse _$NickNameListByPhoneResponseFromJson(
        Map<String, dynamic> json) =>
    NickNameListByPhoneResponse(
      nicknames:
          (json['nicknames'] as List<dynamic>).map((e) => e as String).toList(),
      answerNickName: json['answerNickName'] as String,
    );

Map<String, dynamic> _$NickNameListByPhoneResponseToJson(
        NickNameListByPhoneResponse instance) =>
    <String, dynamic>{
      'nicknames': instance.nicknames,
      'answerNickName': instance.answerNickName,
    };
