part of 'splash_bloc.dart';

abstract class SplashEvent{
  const SplashEvent();
}

class SplashInitEvent extends SplashEvent{
  const SplashInitEvent();
}
