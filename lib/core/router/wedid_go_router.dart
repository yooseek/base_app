import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      path: '/onboard',
      name: 'onboard',
      builder: (context, state) => const OnboardProvider(),
    ),
    GoRoute(
      path: '/signIn',
      name: 'signIn',
      builder: (context, state) => const SigninProvider(),
      routes: [
        GoRoute(
          path: 'changePhoneNum',
          name: 'changePhoneNum',
          builder: (context, state) => const SigninChangePhoneNumberProvider(),
        ),
      ]
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

    final onboard = goState.location == '/onboard';
    final signin = goState.location.contains('/signIn');
    final signup = goState.location.contains('/signUp');

    if(authStatus == GoRouterAuth.unAuth && !onboard && !signin &&!signup) {
      return '/onboard';
    }

    return null;
  }
}