import 'package:json_annotation/json_annotation.dart';

part 'wedid_error.g.dart';

@JsonSerializable()
class WEDIDError {

  final int timestamp;
  final int status;
  final String message;
  final String exception;

  const WEDIDError({
    required this.timestamp,
    required this.status,
    required this.message,
    required this.exception,
  });

  factory WEDIDError.fromJson(Map<String, dynamic> json) => _$WEDIDErrorFromJson(json);

  Map<String, dynamic> toJson() => _$WEDIDErrorToJson(this);

  @override
  String toString() {
    return 'WEDIDError{timestamp: $timestamp, status: $status, message: $message, exception: $exception}';
  }

}