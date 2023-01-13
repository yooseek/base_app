import 'package:json_annotation/json_annotation.dart';

part 'wedid_response.g.dart';

@JsonSerializable(
    genericArgumentFactories: true
)
class WEDIDResponse<T> {

  final int timestamp;
  final T data;

  const WEDIDResponse({required this.timestamp, required this.data});

  factory WEDIDResponse.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT,) => _$WEDIDResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => _$WEDIDResponseToJson(this, toJsonT);

  @override
  String toString() {
    return 'WEDIDResponse{timestamp: $timestamp, data: $data}';
  }
}