// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpRequest _$SignUpRequestFromJson(Map<String, dynamic> json) =>
    SignUpRequest(
      realName: json['realName'] as String,
      birthDay: json['birthDay'] as String,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      phoneNumber: json['phoneNumber'] as String,
    );

Map<String, dynamic> _$SignUpRequestToJson(SignUpRequest instance) =>
    <String, dynamic>{
      'realName': instance.realName,
      'birthDay': instance.birthDay,
      'gender': _$GenderEnumMap[instance.gender]!,
      'phoneNumber': instance.phoneNumber,
    };

const _$GenderEnumMap = {
  Gender.male: 'MALE',
  Gender.female: 'FEMALE',
};
