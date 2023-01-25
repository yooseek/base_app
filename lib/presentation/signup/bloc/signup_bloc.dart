import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:withapp_did/core/wedid_core.dart';
import 'package:withapp_did/domain/wedid_domain.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository authRepository;

  SignupBloc({required this.authRepository}) : super(SignupState.init()) {
    on<SignUpInitEvent>(onSignUpInitEvent);
    on<SetNameEvent>(onSetNameEvent);
    on<SetBirthEvent>(onSetBirthEvent);
    on<SetGenderEvent>(onSetGenderEvent);
    on<SetPhoneNumberEvent>(onSetPhoneNumberEvent);
    on<SetCertNumberEvent>(onSetCertNumberEvent);
    on<ChangeProcessEvent>(onChangeProcessEvent);
  }

  FutureOr<void> onSignUpInitEvent(SignUpInitEvent event, emit) async {
    await emit.onEach(
      authRepository.getNickName,
      onData: (nickName) {
        emit(state.copyWith(nickName: nickName));
      },
      onError: (_, __) {
        debugPrint('getNickName 에러 밟생!');
      },
    );
  }

  FutureOr<void> onSetNameEvent(SetNameEvent event, emit) {
    final valid = event.name.isTrimNotEmpty();

    if (valid) {
      emit(state.copyWith(name: event.name, process: SignUpProcess.birth));
    } else {
      emit(state.copyWith(error: SignUpError.emptyName));
    }
  }

  FutureOr<void> onSetBirthEvent(SetBirthEvent event, emit) {
    final valid = event.birth.length == 10 && event.birth.isDate();

    if (valid) {
      emit(state.copyWith(birth: event.birth, process: SignUpProcess.gender));
    } else {
      emit(state.copyWith(error: SignUpError.wrongBirth));
    }
  }

  FutureOr<void> onSetGenderEvent(SetGenderEvent event, emit) {
    if (event.nextStep) {
      final valid = state.gender != null;

      if (valid) {
        emit(state.copyWith(process: SignUpProcess.phoneNum));
      } else {
        emit(state.copyWith(error: SignUpError.emptyGender));
      }
    } else {
      emit(state.copyWith(gender: event.gender));
    }
  }

  FutureOr<void> onSetPhoneNumberEvent(SetPhoneNumberEvent event, emit) async {
    final valid = event.phoneNumber.isPhoneNumber();

    if (!valid) {
      emit(state.copyWith(error: SignUpError.inValidPhoneNumber));

      return;
    }

    emit(state.copyWith(network: SignUpNetwork.loading));
    final result = await authRepository
        .getPhoneCert(PhoneNumber(phoneNumber: event.phoneNumber));

    result.fold(
          (failure) {
        if (failure is ServerFailure) {
          emit(state.copyWith(error: SignUpError.networkError,network: SignUpNetwork.loaded));
        } else if (failure is NetworkFailure) {
          emit(state.copyWith(error: SignUpError.networkError,network: SignUpNetwork.loaded));
        } else {
          emit(state.copyWith(error: SignUpError.networkError,network: SignUpNetwork.loaded));
        }
      },
          (result) => emit(state.copyWith(
        phoneNumber: event.phoneNumber,
        process: SignUpProcess.verifyPhoneNum,
        network: SignUpNetwork.loaded,
      )),
    );
  }

  FutureOr<void> onSetCertNumberEvent(SetCertNumberEvent event, emit) async {
    final valid = event.certNumber.isCertNumber();

    if(!valid){
      emit(state.copyWith(error: SignUpError.notMatchCertNumber));
      return;
    }

    emit(state.copyWith(network: SignUpNetwork.loading));
    final result = await authRepository.verifyPhone(PhoneAndCert(phoneNumber: state.phoneNumber!, certNumber: event.certNumber));

    await result.fold(
      (failure) {
        if (failure is ServerFailure) {
          switch (failure.error) {
            case NetworkErrorCategory.verificationCodeError:
              emit(state.copyWith(error: SignUpError.inValidCertNumber,network: SignUpNetwork.loaded));
              break;
              /// Todo : 너무 많이 입력함 에러 추가
            case NetworkErrorCategory.certNumberTooManyTry:
              emit(state.copyWith(error: SignUpError.expiredCertNumber,network: SignUpNetwork.loaded));
              break;
            case NetworkErrorCategory.certNumberExpired:
              emit(state.copyWith(error: SignUpError.expiredCertNumber,network: SignUpNetwork.loaded));
              break;
            case NetworkErrorCategory.certNotFound:
              emit(state.copyWith(error: SignUpError.notExistCertNumber,network: SignUpNetwork.loaded));
              break;
            default:
              emit(state.copyWith(error: SignUpError.networkError,network: SignUpNetwork.loaded));
          }
        } else if (failure is NetworkFailure) {
          emit(state.copyWith(error: SignUpError.networkError,network: SignUpNetwork.loaded));
        } else {
          emit(state.copyWith(error: SignUpError.networkError,network: SignUpNetwork.loaded));
        }
      },
      (result) async {
        final signupResult = await authRepository.signUpAuth(
          request: SignUpRequest(
            realName: state.name!,
            birthDay: state.birth!,
            gender: state.gender!,
            phoneNumber: state.phoneNumber!,
          ),
        );

        signupResult.fold(
          (failure) {
            if (failure is ServerFailure) {
              switch (failure.error) {
                case NetworkErrorCategory.memberDuplicateException:
                  emit(state.copyWith(error: SignUpError.existUser,network: SignUpNetwork.loaded));
                  break;
                default:
                  emit(state.copyWith(error: SignUpError.networkError,network: SignUpNetwork.loaded));
              }
            } else {
              emit(state.copyWith(error: SignUpError.networkError,network: SignUpNetwork.loaded));
            }
          },
          (result) => emit(state.copyWith(process: SignUpProcess.welcome,network: SignUpNetwork.loaded)),
        );
      },
    );
  }

  FutureOr<void> onChangeProcessEvent(ChangeProcessEvent event, emit) {
    emit(state.copyWith(process: event.process));
  }
}
