import 'package:json_annotation/json_annotation.dart';

enum Gender {
  @JsonValue('MALE')
  male,
  @JsonValue('FEMALE')
  female,
}