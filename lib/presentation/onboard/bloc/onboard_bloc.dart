import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:withapp_did/domain/auth/auth_domain.dart';

part 'onboard_event.dart';
part 'onboard_state.dart';

class OnboardBloc extends Bloc<OnboardEvent, OnboardState> {
  final AuthRepository authRepository;

  OnboardBloc({required this.authRepository}) : super(OnboardState.init()) {
    on<OnboardInitEvent>(onOnboardInitEvent);
    on<OnboardWatchEvent>(onOnboardWatchEvent);
    on<OnboardLastPageEvent>(onOnboardLastPageEvent);
  }

  FutureOr<void> onOnboardInitEvent(OnboardInitEvent event, emit) async {
    final result = await authRepository.getIsWatchOnBoard();

    result.fold(
      (failure) => emit(state.copyWith(isWatch: false)),
      (result) {
        emit(state.copyWith(isWatch: result));
      },
    );
  }

  FutureOr<void> onOnboardWatchEvent(OnboardWatchEvent event, emit) async {
    final result = await authRepository.setIsWatchOnBoard(true);

    result.fold(
          (failure) => emit(state.copyWith(isWatch: false)),
          (result) {
        emit(state.copyWith(isWatch: result));
      },
    );
  }

  FutureOr<void> onOnboardLastPageEvent(OnboardLastPageEvent event, emit) async {
    emit(state.copyWith(isLast: event.isLast));
  }
}
