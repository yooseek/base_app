// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wedid_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WEDIDResponse<T> _$WEDIDResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    WEDIDResponse<T>(
      timestamp: json['timestamp'] as int,
      data: fromJsonT(json['data']),
    );

Map<String, dynamic> _$WEDIDResponseToJson<T>(
  WEDIDResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'data': toJsonT(instance.data),
    };
