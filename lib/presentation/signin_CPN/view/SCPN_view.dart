import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:withapp_did/core/wedid_core.dart';
import 'package:withapp_did/presentation/signin_CPN/signin_CPN_presentation.dart';

class SignInChangePhoneNumberView extends StatelessWidget {
  const SignInChangePhoneNumberView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SCPNBloc,SCPNState>(
      listenWhen: (previous, current) => previous.error != current.error,
      listener: (context, state) {
        signInChangePhoneNumErrorDialogHandler(context,state.error);
      },
      builder: (context, state) {
        switch (state.process) {
          case SCPNProcess.phoneNum:
            return SCPNPhoneWidget();
          case SCPNProcess.matchNickName:
            return const SCPNMatchNickNameWidget();
          case SCPNProcess.changePhoneNum:
            return SCPNChangePhoneWidget();
          default:
            return SCPNPhoneWidget();
        }
      },
    );
  }
}

class SCPNPhoneWidget extends StatelessWidget {
  SCPNPhoneWidget({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SignInChangePhoneNumberBaseWidget(
      title: '기존 계정에 등록된\n휴대폰 번호를 입력해 주세요',
      mainWidget: signInChangePhoneNumberTextField,
      backButtonCallback: () {
        context.pop();
      },
      nextButtonCallback: () {
        context
            .read<SCPNBloc>()
            .add(SetSCPNPhoneNumEvent(phoneNumber: controller.value.text));
      },
    );
  }

  Container signInChangePhoneNumberTextField(BuildContext context) {
    return Container(
      width: 240.w,
      height: 44.h,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: WEDIDColor.w484848),
        color: WEDIDColor.w222222,
      ),
      child: Row(
        children: [
          Container(
            width: 55.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: WEDIDColor.w484848,
            ),
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 4.w),
            child: Row(
              children: [
                Expanded(
                    child:
                    Image.asset(WEDIDImage.koreaIcon, fit: BoxFit.contain)),
                SizedBox(width: 1.w),
                Text('+82',
                    style: WEDIDTextStyle.nanumSquareNeoE
                        .copyWith(fontSize: 10.sp)),
              ],
            ),
          ),
          Expanded(
            child: WEDIDTextField(
              controller: controller,
              labelText: '휴대폰 번호',
              keyboardType: TextInputType.phone,
              submitCallback: (val) {
                context.read<SCPNBloc>().add(
                    SetSCPNPhoneNumEvent(phoneNumber: controller.value.text));
              },
              isBoarder: false,
            ),
          ),
        ],
      ),
    );
  }
}

class SCPNMatchNickNameWidget extends StatelessWidget {
  const SCPNMatchNickNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInChangePhoneNumberBaseWidget(
      title: '이미 등록된 계정이 있네요!',
      mainWidget: signInMatchNickName,
      subTitle: '기존 계정의 닉네임을 맞춰주세요',
      backButtonCallback: () {
        context
            .read<SCPNBloc>()
            .add(const ChangeSCPNSProcessEvent(process: SCPNProcess.phoneNum));
      },
      nextButtonCallback: () {},
    );
  }

  Column signInMatchNickName(BuildContext context) {
    final nickNameList = context.watch<SCPNBloc>().state.nickNames ?? [];
    final blurNickNameList = context.watch<SCPNBloc>().state.isBlurNickNames ?? [];

    if(nickNameList.isNotEmpty) {
      return Column(
        children: [
          nickNameContainer(nickNameList[0],blurNickNameList[0],(){
            context.read<SCPNBloc>().add(MatchNickNameEvent(nickname: nickNameList[0]));
          }),
          SizedBox(height: 14.h),
          nickNameContainer(nickNameList[1],blurNickNameList[1],(){
            context.read<SCPNBloc>().add(MatchNickNameEvent(nickname: nickNameList[1]));
          }),
          SizedBox(height: 14.h),
          nickNameContainer(nickNameList[2],blurNickNameList[2],(){
            context.read<SCPNBloc>().add(MatchNickNameEvent(nickname: nickNameList[2]));
          }),
          SizedBox(height: 14.h),
          nickNameContainer(nickNameList[3],blurNickNameList[3],(){
            context.read<SCPNBloc>().add(MatchNickNameEvent(nickname: nickNameList[3]));
          }),
          SizedBox(height: 14.h),
          nickNameContainer(nickNameList[4],blurNickNameList[4],(){
            context.read<SCPNBloc>().add(MatchNickNameEvent(nickname: nickNameList[4]));
          }),
          SizedBox(height: 25.h),
          InkWell(
            onTap: (){
              context.goNamed('signUp');
            },
            child: Text('새 계정 만들기',style: WEDIDTextStyle.nanumSquareNeoE.copyWith(fontSize: 12.sp,color: WEDIDColor.w484848)),
          ),
        ],
      );
    }else{
      return Column(
        children: [
          nickNameContainer('오류 발생',false,(){}),
        ],
      );
    }
  }

  InkWell nickNameContainer(String nickname,bool isBlur, VoidCallback onTap) {
    return InkWell(
      onTap: isBlur ? null : onTap,
      child: Container(
        height: 41.h,
        width: 237.w,
        decoration: BoxDecoration(
            color: WEDIDColor.w222222,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: WEDIDColor.w484848)
        ),
        alignment: Alignment.center,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: isBlur ? 2.0 : 0,sigmaY: isBlur ? 2.0 : 0),
          child: Text(nickname,style: WEDIDTextStyle.nanumSquareNeoE.copyWith(fontSize: 16.sp)),
        ),
      ),
    );
  }
}

class SCPNChangePhoneWidget extends StatelessWidget {
  SCPNChangePhoneWidget({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SignInChangePhoneNumberBaseWidget(
      title: '변경할 휴대폰 번호를\n입력해 주세요',
      mainWidget: signInChangePhoneNumberTextField,
      backButtonCallback: () {
        context
            .read<SCPNBloc>()
            .add(const ChangeSCPNSProcessEvent(process: SCPNProcess.matchNickName));
      },
      nextButtonCallback: () {
        context.read<SCPNBloc>().add(
            ChangePhoneNumEvent(phoneNumber: controller.value.text));
      },
    );
  }

  Container signInChangePhoneNumberTextField(BuildContext context) {
    return Container(
      width: 240.w,
      height: 44.h,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: WEDIDColor.w484848),
        color: WEDIDColor.w222222,
      ),
      child: Row(
        children: [
          Container(
            width: 55.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: WEDIDColor.w484848,
            ),
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 4.w),
            child: Row(
              children: [
                Expanded(
                    child:
                    Image.asset(WEDIDImage.koreaIcon, fit: BoxFit.contain)),
                SizedBox(width: 1.w),
                Text('+82',
                    style: WEDIDTextStyle.nanumSquareNeoE
                        .copyWith(fontSize: 10.sp)),
              ],
            ),
          ),
          Expanded(
            child: WEDIDTextField(
              controller: controller,
              labelText: '휴대폰 번호',
              keyboardType: TextInputType.phone,
              submitCallback: (val) {
                context.read<SCPNBloc>().add(
                    ChangePhoneNumEvent(phoneNumber: controller.value.text));
              },
              isBoarder: false,
            ),
          ),
        ],
      ),
    );
  }
}

class SignInChangePhoneNumberBaseWidget extends StatelessWidget {
  const SignInChangePhoneNumberBaseWidget({
    required this.title,
    this.subTitle,
    required this.mainWidget,
    required this.backButtonCallback,
    required this.nextButtonCallback,
    this.letterCallback,
    this.letter,
    super.key,
  }):assert(letterCallback != null ? letter !=null : letter == null,'Letter 입력바람'),
        assert(letter != null ? letterCallback !=null : letterCallback == null,'LetterCallback 입력바람');

  final String title;
  final String? subTitle;
  final ContextWidget mainWidget;
  final VoidCallback backButtonCallback;
  final VoidCallback nextButtonCallback;
  final VoidCallback? letterCallback;
  final String? letter;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: WEDIDScaffold(
        appbar: WEDIDAppBar(
          title: '',
          leading: InkWell(
            onTap: backButtonCallback,
            child: Icon(Icons.arrow_back_ios, color: WEDIDColor.wFFFFFF),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(child: SizedBox()),
              signInChangePhoneNumberTextTitle(),
              if (subTitle != null) signInChangePhoneNumberSubTextTitle(),
              SizedBox(height: 25.h),
              mainWidget(context),
              const Expanded(child: SizedBox()),
              signInChangePhoneNumberNextButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Text signInChangePhoneNumberTextTitle() {
    return Text(title,
        style: WEDIDTextStyle.nanumSquareNeoE.copyWith(fontSize: 20.sp),textAlign: TextAlign.center);
  }

  Container signInChangePhoneNumberSubTextTitle() {
    return Container(
      margin: EdgeInsets.only(top: 5.h),
      child: Text(subTitle ?? '',
          style: WEDIDTextStyle.nanumSquareNeoE.copyWith(fontSize: 12.sp,color: WEDIDColor.w484848)),
    );
  }

  SignInChangePhoneNumberNextArrowButton signInChangePhoneNumberNextButton(BuildContext context) {
    return SignInChangePhoneNumberNextArrowButton(
      onTap: nextButtonCallback,
      letter: letter ?? '',
      onLetterTap: letterCallback,
    );
  }
}

class SignInChangePhoneNumberNextArrowButton extends StatelessWidget {
  const SignInChangePhoneNumberNextArrowButton({required this.onTap,this.onLetterTap,this.letter = '',super.key});

  final VoidCallback onTap;
  final VoidCallback? onLetterTap;
  final String letter;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SCPNBloc, SCPNState>(
      buildWhen: (previous, current) => previous.network != current.network,
      builder: (context, state) {
        if (state.network == SCPNNetwork.loading) {
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.only(right: 24.w, bottom: 16.h),
              child: const CircularProgressIndicator(),
            ),
          );
        }

        return Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: onLetterTap,
                child: Text(
                  letter,
                  style: WEDIDTextStyle.nanumSquareNeoE.copyWith(fontSize: 12.sp,color: WEDIDColor.w4E4E4E,height: 42.h/12.sp),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  width: 54.w,
                  height: 42.h,
                  margin: EdgeInsets.only(right: 24.w, bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: const Icon(Icons.arrow_forward),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

signInChangePhoneNumErrorDialogHandler(BuildContext context, SCPNError error) {
  switch (error){
    case SCPNError.networkError:
      WEDIDConfirmDialog.confirmDialog(
          context: context,
          title: '네트워크 에러 발생',
          content: '인터넷 연결을 확인 후 다시 시도하세요.');
      break;
    case SCPNError.notExistUser:
      WEDIDConfirmDialog.confirmDialog(
        context: context,
        title: '계정 확인',
        content: '회원정보가 존재하지 않습니다.',
        callback: () {
          Navigator.of(context).pop(true);
          context.goNamed('signUp');
        },
      );
      break;
    case SCPNError.inValidPhoneNum:
      WEDIDConfirmDialog.confirmDialog(
          context: context, title: '다시 입력해 주세요', content: '올바르지 않은 핸드폰 번호입니다.');
      break;
    case SCPNError.tooManyUnMatched:
      WEDIDConfirmDialog.confirmDialog(context: context, title: '잠시만!', content: '아쉽게도 3번이나 틀리셨네요!\n번호 변경을 위해 고객센터로 문의해주세요.');
      break;
    case SCPNError.noError:
      break;
    case SCPNError.done:
      context.pop();
      break;
  }
}