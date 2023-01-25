import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:withapp_did/core/wedid_core.dart';
import 'package:withapp_did/domain/wedid_domain.dart';

part 'dialog_event.dart';
part 'dialog_state.dart';

class DialogBloc extends Bloc<DialogEvent, DialogState> {
  final AuthRepository authRepository;

  DialogBloc({required this.authRepository}) : super(DialogState.init()) {
    on<DialogInitEvent>((event, emit) {
      emit(state.copyWith(title: event.title ?? '알림',content: event.content ?? '',button: event.button ?? '확인',status: DialogStatus.init));
    });

    on<ChangeTitleEvent>((event, emit) {
      emit(state.copyWith(title: event.title));
    });

    on<ChangeContentEvent>((event, emit) {
      emit(state.copyWith(content: event.content));
    });

    on<ChangeButtonEvent>((event, emit) {
      emit(state.copyWith(button: event.button));
    });

    on<ChangeNickNameEvent>(onChangeNickNameEvent);
    on<CheckNickNameDupEvent>(onCheckNickNameDupEvent);
  }


  FutureOr<void> onCheckNickNameDupEvent(CheckNickNameDupEvent event, emit) async {
    final valid = event.nickname.trim().isUnder12Word();

    if(!valid){
      emit(state.copyWith(content: '한글숫자공백을 포함한 3글자 이상\n12글자 이하의 닉네임을 써주세요!'));
      return;
    }

    final result = await authRepository.checkNickNameDup(event.nickname.trim());

    result.fold(
          (failure) => emit(state.copyWith(content: '한글숫자공백을 포함한 3글자 이상\n12글자 이하의 닉네임을 써주세요!')),
          (result) {
        if(result) {
          emit(state.copyWith(content: '오!멋진 닉네임이네요:)',button: '확인'));
        }else{
          emit(state.copyWith(content: '사용중인 닉네임입니다. 다른 닉네임을 써주세요!'));
        }
      },
    );
  }

  FutureOr<void> onChangeNickNameEvent(ChangeNickNameEvent event, emit) async {
    final valid = event.nickname.trim().isUnder12Word();

    if(!valid){
      emit(state.copyWith(content: '한글숫자공백을 포함한 3글자 이상\n12글자 이하의 닉네임을 써주세요!'));
      return;
    }

    final result = await authRepository.changeNickName(event.nickname.trim());

    result.fold(
          (failure) => emit(state.copyWith(content: '한글숫자공백을 포함한 3글자 이상\n12글자 이하의 닉네임을 써주세요!')),
          (result) {
        if(result) {
          emit(state.copyWith(status: DialogStatus.done));
        }
      },
    );
  }
}
