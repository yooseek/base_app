import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:withapp_did/domain/wedid_domain.dart';

part 'go_router_event.dart';

part 'go_router_state.dart';

class GoRouterBloc extends Bloc<GoRouterEvent, GoRouterState>
    with ChangeNotifier {
  final AuthRepository authRepository;
  late final StreamSubscription streamSubscription;

  GoRouterBloc({required this.authRepository}) : super(GoRouterState.init()) {
    streamSubscription = authRepository.getAuth.listen((AuthStatus status) {
      add(ChangeAuthEvent(status: status));
    });

    on<ChangeAuthEvent>((event, emit) {
      switch (event.status) {
        case AuthStatus.auth:
          emit(state.copyWith(status: GoRouterAuth.auth));
          break;
        case AuthStatus.unAuth:
          emit(state.copyWith(status: GoRouterAuth.unAuth));
          break;
        case AuthStatus.init:
          break;
        case AuthStatus.error:
          break;
      }
      notifyListeners();
    });
  }
}
