part of 'signin_bloc.dart';

enum SignInErrorStatus {
  init,
  verifiedError,
  expired,
  notExist,
  noMember,
  networkError,
  error,
}

class SigninState extends Equatable {
  final String? phoneNumber;
  final String? certNumber;
  final SignInErrorStatus errorStatus;

  const SigninState({
    this.phoneNumber,
    this.certNumber,
    required this.errorStatus,
  });

  factory SigninState.init() {
    return const SigninState(errorStatus: SignInErrorStatus.init);
  }

  SigninState copyWith({
    String? phoneNumber,
    String? certNumber,
    SignInErrorStatus? errorStatus,
  }) {
    return SigninState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      certNumber: certNumber ?? this.certNumber,
      errorStatus: errorStatus ?? this.errorStatus,
    );
  }

  @override
  List<Object?> get props => [phoneNumber, certNumber, errorStatus];
}
