import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:withapp_did/core/wedid_core.dart';

import 'package:withapp_did/domain/wedid_domain.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository authRepository;

  SignInBloc({required this.authRepository}) : super(SignInState.init()) {
    on<SetPhoneNumEvent>(_onSetPhoneNumEvent);
    on<SetCertNumEvent>(_onSetCertNumEvent);
    on<ChangeSignInProcessEvent>(_onChangeSignInProcessEvent);
  }

  FutureOr<void> _onSetPhoneNumEvent(SetPhoneNumEvent event, emit) async {
    final valid = event.phoneNumber.isPhoneNumber();

    if (!valid) {
      emit(state.copyWith(error: SignInError.inValidPhoneNumber));

      return;
    }

    emit(state.copyWith(network: SignInNetwork.loading));
    final result = await authRepository
        .getPhoneCert(PhoneNumber(phoneNumber: event.phoneNumber));

    result.fold(
          (failure) {
        if (failure is ServerFailure) {
          emit(state.copyWith(error: SignInError.networkError,network: SignInNetwork.loaded));
        } else if (failure is NetworkFailure) {
          emit(state.copyWith(error: SignInError.networkError,network: SignInNetwork.loaded));
        } else {
          emit(state.copyWith(error: SignInError.networkError,network: SignInNetwork.loaded));
        }
      },
          (result) => emit(state.copyWith(
        phoneNumber: event.phoneNumber,
        process: SignInProcess.verifyPhoneNum,
        network: SignInNetwork.loaded,
      )),
    );
  }

  FutureOr<void> _onSetCertNumEvent(SetCertNumEvent event, emit) async {
    final valid = event.certNumber.isCertNumber();

    if(!valid){
      emit(state.copyWith(error: SignInError.notMatchCertNumber));
      return;
    }

    emit(state.copyWith(network: SignInNetwork.loading));
    final result = await authRepository.verifyPhone(PhoneAndCert(phoneNumber: state.phoneNumber!, certNumber: event.certNumber));

    await result.fold(
          (failure) {
        if (failure is ServerFailure) {
          switch (failure.error) {
            case NetworkErrorCategory.verificationCodeError:
              emit(state.copyWith(error: SignInError.inValidCertNumber,network: SignInNetwork.loaded));
              break;
          /// Todo : 너무 많이 입력함 에러 추가
            case NetworkErrorCategory.certNumberTooManyTry:
              emit(state.copyWith(error: SignInError.expiredCertNumber,network: SignInNetwork.loaded));
              break;
            case NetworkErrorCategory.certNumberExpired:
              emit(state.copyWith(error: SignInError.expiredCertNumber,network: SignInNetwork.loaded));
              break;
            case NetworkErrorCategory.certNotFound:
              emit(state.copyWith(error: SignInError.notExistCertNumber,network: SignInNetwork.loaded));
              break;
            default:
              emit(state.copyWith(error: SignInError.networkError,network: SignInNetwork.loaded));
          }
        } else if (failure is NetworkFailure) {
          emit(state.copyWith(error: SignInError.networkError,network: SignInNetwork.loaded));
        } else {
          emit(state.copyWith(error: SignInError.networkError,network: SignInNetwork.loaded));
        }
      },
          (result) async {
            if(result == 'unAuth Success') {
              /// 회원가입 안되어 있음
              emit(state.copyWith(error: SignInError.notExistUser,network: SignInNetwork.loaded));
            }else{
              emit(state.copyWith(error: SignInError.done,network: SignInNetwork.loaded));
            }
      },
    );
  }

  FutureOr<void> _onChangeSignInProcessEvent(ChangeSignInProcessEvent event, emit){
    emit(state.copyWith(process: event.process));
  }
}
