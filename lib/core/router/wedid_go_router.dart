import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:withapp_did/domain/wedid_domain.dart';
import 'package:withapp_did/injection_container.dart';

import 'package:withapp_did/presentation/wedid_presentation.dart' hide GoRouterState;

class WEDIDGoRouterConfig {

  final GlobalKey<NavigatorState> _rootNavigatorKey =
  GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _shellNavigatorKey =
  GlobalKey<NavigatorState>(debugLabel: 'shell');

  GoRouter initialGoRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      routes: routes,
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: serviceLocator<GoRouterBloc>(),
      redirect: redirectLogic
    );
  }

  List<RouteBase> get routes => [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: '/signIn',
      name: 'signIn',
      builder: (context, state) => const SigninProvider(),
    ),
    GoRoute(
      path: '/signUp',
      name: 'signUp',
      builder: (context, state) => const SignupProvider(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeProvider(),
    ),
  ];

  String? redirectLogic(BuildContext context, GoRouterState goState) {
    final state = serviceLocator<GoRouterBloc>().state;

    final authStatus = state.status;

    final signin = goState.location == '/signIn';
    final signup = goState.location == '/signUp';


    if(authStatus == GoRouterAuth.unAuth && !signin &&!signup) {
      return '/signIn';
    }

    return null;
  }
}