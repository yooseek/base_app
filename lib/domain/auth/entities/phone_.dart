import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'phone_.g.dart';

@JsonSerializable()
class PhoneNumber extends Equatable{
  final String phoneNumber;

  const PhoneNumber({
    required this.phoneNumber,
  });

  PhoneNumber copyWith({
    String? phoneNumber,
  }) {
    return PhoneNumber(
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  factory PhoneNumber.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumberFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneNumberToJson(this);

  @override
  List<Object> get props => [phoneNumber];
}