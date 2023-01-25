// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_nickname_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchNickNameResponse _$MatchNickNameResponseFromJson(
        Map<String, dynamic> json) =>
    MatchNickNameResponse(
      tryCount: json['tryCount'] as int,
      isSuccess: json['isSuccess'] as bool,
    );

Map<String, dynamic> _$MatchNickNameResponseToJson(
        MatchNickNameResponse instance) =>
    <String, dynamic>{
      'tryCount': instance.tryCount,
      'isSuccess': instance.isSuccess,
    };
