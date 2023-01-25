import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:withapp_did/core/wedid_core.dart';

import 'package:withapp_did/domain/wedid_domain.dart';

part 'scpn_event.dart';

part 'scpn_state.dart';

class SCPNBloc extends Bloc<SCPNEvent, SCPNState> {
  final AuthRepository authRepository;

  SCPNBloc({required this.authRepository}) : super(SCPNState.init()) {
    on<SetSCPNPhoneNumEvent>(_onSetSCPNPhoneNumEvent);
    on<MatchNickNameEvent>(_onMatchNickNameEvent);
    on<ChangePhoneNumEvent>(_onChangePhoneNumEvent);
    on<ChangeSCPNSProcessEvent>(_onChangeSCPNSProcessEvent);
  }

  FutureOr<void> _onSetSCPNPhoneNumEvent(SetSCPNPhoneNumEvent event, emit) async {
    final valid = event.phoneNumber.isPhoneNumber();

    if (!valid) {
      emit(state.copyWith(error: SCPNError.inValidPhoneNum));
      return;
    }

    emit(state.copyWith(network: SCPNNetwork.loading));
    final result = await authRepository.getNickNameList(event.phoneNumber);

    result.fold(
      (failure) {
        if (failure is ServerFailure) {
          switch (failure.error) {
            case NetworkErrorCategory.memberNotFoundException:
              emit(state.copyWith(
                  error: SCPNError.notExistUser, network: SCPNNetwork.loaded));
              break;
            default:
              emit(state.copyWith(
                  error: SCPNError.networkError, network: SCPNNetwork.loaded));
          }
        } else if (failure is NetworkFailure) {
          emit(state.copyWith(
              error: SCPNError.networkError, network: SCPNNetwork.loaded));
        } else {
          emit(state.copyWith(
              error: SCPNError.networkError, network: SCPNNetwork.loaded));
        }
      },
      (result) {
        emit(state.copyWith(
          phoneNumber: event.phoneNumber,
          nickNames: result.nicknames,
          isBlurNickNames:
              List.generate(result.nicknames.length, (index) => false),
          nickname: result.answerNickName,
          process: SCPNProcess.matchNickName,
          network: SCPNNetwork.loaded,
        ));
      },
    );
  }

  FutureOr<void> _onMatchNickNameEvent(MatchNickNameEvent event, emit) async {
    if (state.phoneNumber == null || state.nickNames == null) {
      return;
    }

    emit(state.copyWith(network: SCPNNetwork.loading));
    final result =
        await authRepository.matchNickName(state.phoneNumber!, event.nickname);

    result.fold(
      (failure) {
        if (failure is ServerFailure) {
          switch (failure.error) {
            case NetworkErrorCategory.memberNotFoundException:
              emit(state.copyWith(
                  error: SCPNError.notExistUser, network: SCPNNetwork.loaded));
              break;
            case NetworkErrorCategory.memberPhoneChangeTooManyException:
              emit(state.copyWith(
                  error: SCPNError.tooManyUnMatched,
                  network: SCPNNetwork.loaded));
              break;
            default:
              emit(state.copyWith(
                  error: SCPNError.networkError, network: SCPNNetwork.loaded));
          }
        } else if (failure is NetworkFailure) {
          emit(state.copyWith(
              error: SCPNError.networkError, network: SCPNNetwork.loaded));
        } else {
          emit(state.copyWith(
              error: SCPNError.networkError, network: SCPNNetwork.loaded));
        }
      },
      (result) {
        if (result.isSuccess) {
          emit(state.copyWith(
            process: SCPNProcess.changePhoneNum,
            network: SCPNNetwork.loaded,
          ));
        } else {
          final nickNameIndex = state.nickNames!
              .indexWhere((element) => element.contains(event.nickname));
          final newFilterList = state.isBlurNickNames!.toList();
          newFilterList[nickNameIndex] = true;

          emit(state.copyWith(
            isBlurNickNames: newFilterList,
            network: SCPNNetwork.loaded,
          ));
        }
      },
    );
  }

  FutureOr<void> _onChangePhoneNumEvent(ChangePhoneNumEvent event, emit) async {
    final valid = event.phoneNumber.isPhoneNumber();

    if (!valid) {
      emit(state.copyWith(error: SCPNError.inValidPhoneNum));
      return;
    }

    if (state.phoneNumber == null || state.nickNames == null) {
      return;
    }

    emit(state.copyWith(network: SCPNNetwork.loading));
    final result =
        await authRepository.changePhone(state.phoneNumber!, event.phoneNumber);

    result.fold(
      (failure) {
        if (failure is ServerFailure) {
          switch (failure.error) {
            case NetworkErrorCategory.memberNotFoundException:
              emit(state.copyWith(
                  error: SCPNError.notExistUser, network: SCPNNetwork.loaded));
              break;
            default:
              emit(state.copyWith(
                  error: SCPNError.networkError, network: SCPNNetwork.loaded));
          }
        } else if (failure is NetworkFailure) {
          emit(state.copyWith(
              error: SCPNError.networkError, network: SCPNNetwork.loaded));
        } else {
          emit(state.copyWith(
              error: SCPNError.networkError, network: SCPNNetwork.loaded));
        }
      },
      (result) {
        emit(state.copyWith(error: SCPNError.done));
      },
    );
  }

  FutureOr<void> _onChangeSCPNSProcessEvent(ChangeSCPNSProcessEvent event, emit) {
    emit(state.copyWith(process: event.process));
  }
}
