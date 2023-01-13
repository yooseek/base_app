import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:withapp_did/core/wedid_core.dart';

import 'package:withapp_did/domain/wedid_domain.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final AuthRepository authRepository;

  SigninBloc({required this.authRepository}) : super(SigninState.init()) {
    on<GetCertNumber>(_onGetCertNumber);
    on<VerifyPhoneCert>(_onVerifyPhoneCert);
  }

  FutureOr<void> _onGetCertNumber(GetCertNumber event, emit) async {
    final result = await authRepository.getPhoneCert(PhoneNumber(phoneNumber: event.phoneNumber));

    result.fold(
          (failure) {
        if(failure is ServerFailure) {
          switch(failure.msg){
            case "30001":
              emit(state.copyWith(errorStatus: SignInErrorStatus.noMember));
              break;
          }
        }else if(failure is NetworkFailure){
          emit(state.copyWith(errorStatus: SignInErrorStatus.networkError));
        }else{
          emit(state.copyWith(errorStatus: SignInErrorStatus.error));
        }
      },
      (result) => emit(state.copyWith(phoneNumber: event.phoneNumber)),
    );
  }

  FutureOr<void> _onVerifyPhoneCert(VerifyPhoneCert event, emit) async {
    if(state.phoneNumber == null) return;

    final result = await authRepository.verifyPhone(PhoneAndCert(phoneNumber: state.phoneNumber!, certNumber: event.certNumber));

    result.fold(
          (failure) {
            if(failure is ServerFailure) {
              switch(failure.msg){
                case "10001":
                  emit(state.copyWith(errorStatus: SignInErrorStatus.verifiedError));
                  break;
                case "10004":
                  emit(state.copyWith(errorStatus: SignInErrorStatus.expired));
                  break;
                case "10005":
                  emit(state.copyWith(errorStatus: SignInErrorStatus.notExist));
                  break;
                case "30001":
                  emit(state.copyWith(errorStatus: SignInErrorStatus.noMember));
                  break;
              }
            }else if(failure is NetworkFailure){
              emit(state.copyWith(errorStatus: SignInErrorStatus.networkError));
            }else{
              emit(state.copyWith(errorStatus: SignInErrorStatus.error));
            }
          },
          (result) => emit(state.copyWith(certNumber: event.certNumber)),
    );
  }
}
