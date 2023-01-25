part of 'onboard_bloc.dart';

abstract class OnboardEvent {
  const OnboardEvent();
}

class OnboardInitEvent extends OnboardEvent {
  const OnboardInitEvent();
}

class OnboardWatchEvent extends OnboardEvent {
  const OnboardWatchEvent();
}

class OnboardLastPageEvent extends OnboardEvent {
  final bool isLast;

  const OnboardLastPageEvent({required this.isLast});
}