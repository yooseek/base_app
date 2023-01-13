import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:withapp_did/domain/wedid_domain.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepository authRepository;

  SplashBloc({required this.authRepository}) : super(SplashInitial()) {
    on<SplashInitEvent>(_onSplashInitEvent);
  }

  FutureOr<void> _onSplashInitEvent(SplashInitEvent event, emit) async {
    await authRepository.checkAuth();

    await emit.onEach(
      authRepository.getAuth,
      onData: (auth) {
        if(auth == AuthStatus.auth){
          emit(SplashAuth());
        }else if(auth == AuthStatus.unAuth) {
          emit(SplashUnAuth());
        }else if(auth == AuthStatus.error){
          emit(SplashError());
        }
      },
      onError: (_, __) {
        debugPrint('getAuth 에러 밟생!');
      },
    );
  }
}
