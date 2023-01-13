part of 'go_router_bloc.dart';

enum GoRouterAuth {
  init,
  auth,
  unAuth,
}

class GoRouterState extends Equatable {
  final GoRouterAuth status;

  const GoRouterState({
    required this.status,
  });

  factory GoRouterState.init () {
    return const GoRouterState(status: GoRouterAuth.init);
  }

  GoRouterState copyWith({
    GoRouterAuth? status,
  }) {
    return GoRouterState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status];
}
