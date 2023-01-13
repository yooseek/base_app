part of 'go_router_bloc.dart';

abstract class GoRouterEvent{
  const GoRouterEvent();
}

class ChangeAuthEvent extends GoRouterEvent {
  final AuthStatus status;

  const ChangeAuthEvent({required this.status});
}