import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:withapp_did/core/wedid_core.dart';
import 'package:withapp_did/presentation/wedid_presentation.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInBloc,SignInState>(
      listenWhen: (previous, current) => previous.error != current.error,
      listener: (context, state) {
        signInErrorDialogHandler(context,state.error);
      },
      builder: (context, state) {
        switch (state.process) {
          case SignInProcess.phoneNum:
            return SignInPhoneNumWidget();
          case SignInProcess.verifyPhoneNum:
            return const SignInCertNumWidget();
          default:
            return SignInPhoneNumWidget();
        }
      },
    );
  }
}

class SignInPhoneNumWidget extends StatelessWidget {
  SignInPhoneNumWidget({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SignInBaseWidget(
      title: '휴대폰번호로 로그인',
      subTitle: '서비스 이용을 위해 번호 인증을 해주세요',
      mainWidget: signInTextField,
      backButtonCallback: () {
        context.goNamed('onboard');
      },
      nextButtonCallback: () {
        context.read<SignInBloc>().add(SetPhoneNumEvent(phoneNumber: controller.value.text));
      },
      letter: '휴대폰 번호가 변경되셨나요?',
      letterCallback: (){
        context.goNamed('changePhoneNum');
      },
    );
  }

  Container signInTextField(BuildContext context) {
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
                    child: Image.asset(WEDIDImage.koreaIcon, fit: BoxFit.contain)),
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
                context.read<SignInBloc>().add(
                    SetPhoneNumEvent(phoneNumber: controller.value.text));
              },
              isBoarder: false,
            ),
          ),
        ],
      ),
    );
  }
}

class SignInCertNumWidget extends StatefulWidget {
  const SignInCertNumWidget({super.key});

  @override
  State<SignInCertNumWidget> createState() => _SignInCertNumWidgetState();
}

class _SignInCertNumWidgetState extends State<SignInCertNumWidget> {
  final TextEditingController controllerA = TextEditingController();
  final TextEditingController controllerB = TextEditingController();
  final TextEditingController controllerC = TextEditingController();
  final TextEditingController controllerD = TextEditingController();
  final TextEditingController controllerE = TextEditingController();
  final TextEditingController controllerF = TextEditingController();
  final FocusNode focusNodeA = FocusNode();
  final FocusNode focusNodeB = FocusNode();
  final FocusNode focusNodeC = FocusNode();
  final FocusNode focusNodeD = FocusNode();
  final FocusNode focusNodeE = FocusNode();
  final FocusNode focusNodeF = FocusNode();

  @override
  void initState() {
    super.initState();
    controllerA.addListener(
            () => controllerListener(controllerA, focusNodeA, focusNodeB));
    controllerB.addListener(
            () => controllerListener(controllerB, focusNodeB, focusNodeC));
    controllerC.addListener(
            () => controllerListener(controllerC, focusNodeC, focusNodeD));
    controllerD.addListener(
            () => controllerListener(controllerD, focusNodeD, focusNodeE));
    controllerE.addListener(
            () => controllerListener(controllerE, focusNodeE, focusNodeF));
    controllerF.addListener(
            () => controllerListener(controllerF, focusNodeF, focusNodeA));
  }

  void controllerListener(TextEditingController thisController,
      FocusNode thisFocus, FocusNode nextFocus) {
    if (thisController == controllerF) {
      if (thisController.value.selection ==
          const TextSelection.collapsed(offset: 1)) {
        FocusScope.of(context).unfocus();
        return;
      }else if(thisController.value.selection == const TextSelection.collapsed(offset: 2)){
        thisController.text = thisController.value.text.substring(1,2);
        FocusScope.of(context).unfocus();
      }
    }
    if (thisController.value.selection ==
        const TextSelection.collapsed(offset: 1)) {
      FocusScope.of(context).requestFocus(nextFocus);
    }else if(thisController.value.selection == const TextSelection.collapsed(offset: 2)){
      thisController.text = thisController.value.text.substring(1,2);
      FocusScope.of(context).requestFocus(nextFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    final phone =
        context.watch<SignInBloc>().state.phoneNumber ?? '01012341234';

    return SignInBaseWidget(
      title: '인증번호를 입력해주세요',
      subTitle: '+82${phone.substring(1)}로 전송됨',
      mainWidget: signInTextField,
      backButtonCallback: () {
        context
            .read<SignInBloc>()
            .add(const ChangeSignInProcessEvent(process: SignInProcess.phoneNum));
      },
      nextButtonCallback: () {
        final certNum =
            '${controllerA.value.text}${controllerB.value.text}${controllerC.value.text}${controllerD.value.text}${controllerE.value.text}${controllerF.value.text}';
        context.read<SignInBloc>().add(SetCertNumEvent(certNumber: certNum));
      },
      letter: '인증번호 다시 받기',
      letterCallback: (){
        context
            .read<SignupBloc>()
            .add(SetPhoneNumberEvent(phoneNumber: phone));
      },
    );
  }

  Widget signInTextField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 43.w,
          height: 44.h,
          child: WEDIDTextField(
            controller: controllerA,
            focusNode: focusNodeA,
            isCenter: true,
            labelText: '',
            keyboardType: TextInputType.phone,
            submitCallback: (val) {},
          ),
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 43.w,
          height: 44.h,
          child: WEDIDTextField(
            controller: controllerB,
            focusNode: focusNodeB,
            isCenter: true,
            labelText: '',
            keyboardType: TextInputType.phone,
            submitCallback: (val) {},
          ),
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 43.w,
          height: 44.h,
          child: WEDIDTextField(
            controller: controllerC,
            focusNode: focusNodeC,
            isCenter: true,
            labelText: '',
            keyboardType: TextInputType.phone,
            submitCallback: (val) {},
          ),
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 43.w,
          height: 44.h,
          child: WEDIDTextField(
            controller: controllerD,
            focusNode: focusNodeD,
            isCenter: true,
            labelText: '',
            keyboardType: TextInputType.phone,
            submitCallback: (val) {},
          ),
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 43.w,
          height: 44.h,
          child: WEDIDTextField(
            controller: controllerE,
            focusNode: focusNodeE,
            isCenter: true,
            labelText: '',
            keyboardType: TextInputType.phone,
            submitCallback: (val) {},
          ),
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 43.w,
          height: 44.h,
          child: WEDIDTextField(
            controller: controllerF,
            focusNode: focusNodeF,
            isCenter: true,
            labelText: '',
            keyboardType: TextInputType.phone,
            submitCallback: (val) {},
          ),
        ),
      ],
    );
  }
}

class SignInBaseWidget extends StatelessWidget {
  const SignInBaseWidget({
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
              signInTextTitle(),
              if (subTitle != null) signInSubTextTitle(),
              SizedBox(height: 25.h),
              mainWidget(context),
              const Expanded(child: SizedBox()),
              signInNextButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Text signInTextTitle() {
    return Text(title,
        style: WEDIDTextStyle.nanumSquareNeoE.copyWith(fontSize: 20.sp),textAlign: TextAlign.center);
  }

  Container signInSubTextTitle() {
    return Container(
      margin: EdgeInsets.only(top: 5.h),
      child: Text(subTitle ?? '',
          style: WEDIDTextStyle.nanumSquareNeoE.copyWith(fontSize: 12.sp,color: WEDIDColor.w484848)),
    );
  }

  SignInNextArrowButton signInNextButton(BuildContext context) {
    return SignInNextArrowButton(
      onTap: nextButtonCallback,
      letter: letter ?? '',
      onLetterTap: letterCallback,
    );
  }
}

class SignInNextArrowButton extends StatelessWidget {
  const SignInNextArrowButton({required this.onTap,this.onLetterTap,this.letter = '',super.key});

  final VoidCallback onTap;
  final VoidCallback? onLetterTap;
  final String letter;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.network != current.network,
      builder: (context, state) {
        if (state.network == SignInNetwork.loading) {
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

signInErrorDialogHandler(BuildContext context, SignInError error) {
  switch (error){
    case SignInError.networkError:
      WEDIDConfirmDialog.confirmDialog(
          context: context,
          title: '네트워크 에러 발생',
          content: '인터넷 연결을 확인 후 다시 시도하세요.');
      break;
    case SignInError.inValidPhoneNumber:
      WEDIDConfirmDialog.confirmDialog(
          context: context, title: '다시 입력해 주세요', content: '올바르지 않은 핸드폰 번호입니다.');
      break;
    case SignInError.notMatchCertNumber:
      WEDIDConfirmDialog.confirmDialog(
          context: context, title: '다시 입력해 주세요', content: '잘못된 인증 번호입니다.');
      break;
    /// Todo: 다시 보내드리는 로직이 필요할까? 글 수정하기?
    case SignInError.inValidCertNumber:
      WEDIDConfirmDialog.confirmDialog(
          context: context,
          title: '다시 입력해 주세요',
          content: '보내드린 인증번호와 다르네요\n다시 보내드릴까요?');
      break;
    case SignInError.expiredCertNumber:
      WEDIDConfirmDialog.confirmDialog(
          context: context,
          title: '다시 입력해 주세요',
          content: '보내드린 인증번호가 만료되었습니다\n다시 보내드릴까요?');
      break;
    case SignInError.notExistCertNumber:
      WEDIDConfirmDialog.confirmDialog(
          context: context, title: '다시 입력해 주세요', content: '인증번호를 받지 않으셨습니다.');
      break;
    case SignInError.notExistUser:
      WEDIDConfirmDialog.confirmDialog(
        context: context,
        title: '로그인',
        content: '회원정보가 존재하지 않습니다.',
        callback: () {
          Navigator.of(context).pop(true);
          context.goNamed('signUp');
        },
      );
      break;
    case SignInError.done:
      context.goNamed('home');
      break;
    case SignInError.noError:
      break;
  }
}