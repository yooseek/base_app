import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'phone_and_cert.g.dart';

@JsonSerializable()
class PhoneAndCert extends Equatable {
  final String phoneNumber;
  final String certNumber;

  const PhoneAndCert({
    required this.phoneNumber,
    required this.certNumber,
  });

  PhoneAndCert copyWith({
    String? phoneNumber,
    String? certNumber,
  }) {
    return PhoneAndCert(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      certNumber: certNumber ?? this.certNumber,
    );
  }

  factory PhoneAndCert.fromJson(Map<String, dynamic> json) => _$PhoneAndCertFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneAndCertToJson(this);

  @override
  String toString() {
    return 'PhoneAndCert{phoneNum: $phoneNumber, certNum: $certNumber}';
  }

  @override
  List<Object> get props => [phoneNumber, certNumber];
}