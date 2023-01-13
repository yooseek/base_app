import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token.g.dart';

@JsonSerializable()
class RefreshToken extends Equatable{
  final String refreshToken;

  const RefreshToken({
    required this.refreshToken,
  });

  RefreshToken copyWith({
    String? refreshToken,
  }) {
    return RefreshToken(
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  factory RefreshToken.fromJson(Map<String, dynamic> json) => _$RefreshTokenFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenToJson(this);

  @override
  List<Object> get props => [refreshToken];
}