// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wedid_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WEDIDError _$WEDIDErrorFromJson(Map<String, dynamic> json) => WEDIDError(
      timestamp: json['timestamp'] as int,
      status: json['status'] as int,
      message: json['message'] as String,
      exception: json['exception'] as String,
    );

Map<String, dynamic> _$WEDIDErrorToJson(WEDIDError instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'status': instance.status,
      'message': instance.message,
      'exception': instance.exception,
    };
