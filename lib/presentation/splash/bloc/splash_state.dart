part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  const SplashState();
}

class SplashInitial extends SplashState {
  @override
  List<Object> get props => [];
}

class SplashAuth extends SplashState {
  @override
  List<Object> get props => [];
}

class SplashUnAuth extends SplashState {
  @override
  List<Object> get props => [];
}

class SplashError extends SplashState {
  @override
  List<Object> get props => [];
}