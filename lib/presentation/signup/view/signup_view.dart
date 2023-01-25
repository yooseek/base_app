import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:withapp_did/core/wedid_core.dart';
import 'package:withapp_did/presentation/wedid_presentation.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, SignupState>(
      listenWhen: (previous, current) => previous.error != current.error,
      listener: (context, state) {
        signUpErrorDialogHandler(context, state.error);
      },
      builder: (context, state) {
        switch (state.process) {
          case SignUpProcess.name:
            return SignUpNameWidget();
          case SignUpProcess.birth:
            return const SignUpBirthWidget();
          case SignUpProcess.gender:
            return const SignUpGenderWidget();
          case SignUpProcess.phoneNum:
            return SignUpPhoneNumWidget();
          case SignUpProcess.verifyPhoneNum:
            return const SignUpCertNumWidget();
          case SignUpProcess.welcome:
            return const SignUpWelcomeWidget();
          default:
            return SignUpNameWidget();
        }
      },
    );
  }
}

class SignUpNameWidget extends StatelessWidget {
  SignUpNameWidget({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SignUpBaseWidget(
      title: '안녕하세요!\n이름을 알려주세요',
      mainWidget: signUpTextField,
      backButtonCallback: () {
        context.goNamed('onboard');
      },
      nextButtonCallback: () {
        context
            .read<SignupBloc>()
            .add(SetNameEvent(name: controller.value.text));
      },
    );
  }

  SizedBox signUpTextField(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: 44.h,
      child: WEDIDTextField(
        controller: controller,
        labelText: '내 이름',
        submitCallback: (val) {
          context.read<SignupBloc>().add(SetNameEvent(name: val));
        },
      ),
    );
  }
}

class SignUpBirthWidget extends StatefulWidget {
  const SignUpBirthWidget({super.key});

  @override
  State<SignUpBirthWidget> createState() => _SignUpBirthWidgetState();
}

class _SignUpBirthWidgetState extends State<SignUpBirthWidget> {
  final TextEditingController yearController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController dayController = TextEditingController();

  final yearFocusNode = FocusNode();
  final monthFocusNode = FocusNode();
  final dayFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    yearController.addListener(yearControllerListener);
    monthController.addListener(monthControllerListener);
  }

  void yearControllerListener() {
    if (yearController.value.selection ==
        const TextSelection.collapsed(offset: 4)) {
      FocusScope.of(context).requestFocus(monthFocusNode);
    }
  }

  void monthControllerListener() {
    if (monthController.value.selection ==
        const TextSelection.collapsed(offset: 2)) {
      FocusScope.of(context).requestFocus(dayFocusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = context.watch<SignupBloc>().state.name ?? '임시';

    return SignUpBaseWidget(
      title: '$name 님,\n생일은 언제인가요?',
      mainWidget: signUpTextField,
      backButtonCallback: () {
        context
            .read<SignupBloc>()
            .add(const ChangeProcessEvent(process: SignUpProcess.name));
      },
      nextButtonCallback: () {
        final birth =
            '${yearController.value.text}/${monthController.value.text.padLeft(2, '0')}/${dayController.value.text.padLeft(2, '0')}';
        context.read<SignupBloc>().add(SetBirthEvent(birth: birth));
      },
      letter: '예) 2023/1/1',
      letterCallback: (){},
    );
  }

  Row signUpTextField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 64.w,
          height: 44.h,
          child: WEDIDTextField(
            controller: yearController,
            focusNode: yearFocusNode,
            labelText: '년',
            keyboardType: TextInputType.number,
            submitCallback: (val) {},
          ),
        ),
        SizedBox(width: 14.w),
        SizedBox(
          width: 43.w,
          height: 44.h,
          child: WEDIDTextField(
            controller: monthController,
            focusNode: monthFocusNode,
            labelText: '월',
            keyboardType: TextInputType.number,
            submitCallback: (val) {},
          ),
        ),
        SizedBox(width: 14.w),
        SizedBox(
          width: 43.w,
          height: 44.h,
          child: WEDIDTextField(
            controller: dayController,
            focusNode: dayFocusNode,
            labelText: '일',
            keyboardType: TextInputType.number,
            submitCallback: (val) {
              final birth =
                  '${yearController.value.text}/${monthController.value.text.padLeft(2, '0')}/${dayController.value.text.padLeft(2, '0')}';
              context.read<SignupBloc>().add(SetBirthEvent(birth: birth));
            },
          ),
        ),
      ],
    );
  }
}

class SignUpGenderWidget extends StatelessWidget {
  const SignUpGenderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final name = context.watch<SignupBloc>().state.name ?? '임시';

    return SignUpBaseWidget(
      title: '$name 님,\n성별은 무엇인가요?',
      mainWidget: signUpTextField,
      backButtonCallback: () {
        context
            .read<SignupBloc>()
            .add(const ChangeProcessEvent(process: SignUpProcess.birth));
      },
      nextButtonCallback: () {
        context.read<SignupBloc>().add(const SetGenderEvent(nextStep: true));
      },
    );
  }

  Row signUpTextField(BuildContext context) {
    final gender = context.watch<SignupBloc>().state.gender;
    final isMale = gender == Gender.male;
    final isFemale = gender == Gender.female;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            context
                .read<SignupBloc>()
                .add(const SetGenderEvent(gender: Gender.male));
          },
          child: Container(
            height: 44.h,
            width: 71.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: isMale ? WEDIDColor.wFFFFFF : WEDIDColor.w222222,
            ),
            alignment: Alignment.center,
            child: Text(
              '남자',
              style: WEDIDTextStyle.nanumSquareNeoE.copyWith(
                color: isMale ? WEDIDColor.w000000 : WEDIDColor.w484848,
                fontSize: 18.sp,
              ),
            ),
          ),
        ),
        SizedBox(width: 14.w),
        InkWell(
          onTap: () {
            context
                .read<SignupBloc>()
                .add(const SetGenderEvent(gender: Gender.female));
          },
          child: Container(
            height: 44.h,
            width: 71.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: isFemale ? WEDIDColor.wFFFFFF : WEDIDColor.w222222,
            ),
            alignment: Alignment.center,
            child: Text('여자',
                style: WEDIDTextStyle.nanumSquareNeoE.copyWith(
                    color: isFemale ? WEDIDColor.w000000 : WEDIDColor.w484848,
                    fontSize: 18.sp)),
          ),
        ),
      ],
    );
  }
}

class SignUpPhoneNumWidget extends StatelessWidget {
  SignUpPhoneNumWidget({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SignUpBaseWidget(
      title: '본인 확인을 위해\n휴대폰 번호가 필요합니다',
      mainWidget: signUpTextField,
      backButtonCallback: () {
        context
            .read<SignupBloc>()
            .add(const ChangeProcessEvent(process: SignUpProcess.gender));
      },
      nextButtonCallback: () {
        context
            .read<SignupBloc>()
            .add(SetPhoneNumberEvent(phoneNumber: controller.value.text));
      },
    );
  }

  Container signUpTextField(BuildContext context) {
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
                context.read<SignupBloc>().add(
                    SetPhoneNumberEvent(phoneNumber: controller.value.text));
              },
              isBoarder: false,
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpCertNumWidget extends StatefulWidget {
  const SignUpCertNumWidget({super.key});

  @override
  State<SignUpCertNumWidget> createState() => _SignUpCertNumWidgetState();
}

class _SignUpCertNumWidgetState extends State<SignUpCertNumWidget> {
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
        context.watch<SignupBloc>().state.phoneNumber ?? '01012341234';

    return SignUpBaseWidget(
      title: '인증번호를 입력해주세요',
      subTitle: '+82${phone.substring(1)}로 전송됨',
      mainWidget: signUpTextField,
      backButtonCallback: () {
        context
            .read<SignupBloc>()
            .add(const ChangeProcessEvent(process: SignUpProcess.phoneNum));
      },
      nextButtonCallback: () {
        final certNum =
            '${controllerA.value.text}${controllerB.value.text}${controllerC.value.text}${controllerD.value.text}${controllerE.value.text}${controllerF.value.text}';
        context.read<SignupBloc>().add(SetCertNumberEvent(certNumber: certNum));
      },
      letter: '인증번호 다시 받기',
      letterCallback: (){
        context
            .read<SignupBloc>()
            .add(SetPhoneNumberEvent(phoneNumber: phone));
      },
    );
  }

  Widget signUpTextField(BuildContext context) {
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

class SignUpWelcomeWidget extends StatelessWidget {
  const SignUpWelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final nickName = context.watch<SignupBloc>().state.nickName ?? '';

    return WEDIDScaffold(
      child: SafeArea(
        top: true,
        bottom: true,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 102.h),
              welcomeNickName(context, nickName),
              welcomeText('회원가입을 축하합니다!', 26.sp),
              welcomeText('내 스포츠 기록의 시작, WEDID에 오신 걸 환영해요 :)', 12.sp),
              SizedBox(height: 32.h),
              Container(height: 398.h, color: Colors.grey),
              const Spacer(),
              WEDIDButton(
                onClick: () {
                  context.goNamed('home');
                },
                text: '확인',
                fontSize: 14.sp,
              ),
              SizedBox(height: 59.h),
            ],
          ),
        ),
      ),
    );
  }

  Text welcomeText(String text, double fontSize) {
    return Text(
      text,
      style: WEDIDTextStyle.nanumSquareNeoE.copyWith(
          fontSize: fontSize, height: 31.h / fontSize, letterSpacing: -0.3),
    );
  }

  GestureDetector welcomeNickName(BuildContext context, String nickName) {
    return GestureDetector(
      onTap: () {
        textFieldConfirmCancelDialog(
            context: context,
            title: '닉네임 변경',
            content: '12글자 안으로 닉네임을 써주세요!',
            button: '중복체크');
      },
      child: Row(
        children: [
          Text(
            '$nickName님',
            style: WEDIDTextStyle.nanumSquareNeoE.copyWith(
                fontSize: 26.sp,
                decoration: TextDecoration.underline,
                height: 31.h / 26.sp,
                letterSpacing: -0.3),
          ),
          Container(
            height: 31.h / 26.sp,
            alignment: Alignment.bottomCenter,
            child: Icon(Icons.edit, color: Colors.white, size: 14.h),
          ),
        ],
      ),
    );
  }
}

class SignUpBaseWidget extends StatelessWidget {
  const SignUpBaseWidget({
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
              signUpTextTitle(),
              if (subTitle != null) signUpSubTextTitle(),
              SizedBox(height: 25.h),
              mainWidget(context),
              const Expanded(child: SizedBox()),
              signUpNextButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Text signUpTextTitle() {
    return Text(title,
        style: WEDIDTextStyle.nanumSquareNeoE.copyWith(fontSize: 20.sp),textAlign: TextAlign.center);
  }

  Container signUpSubTextTitle() {
    return Container(
      margin: EdgeInsets.only(top: 5.h),
      child: Text(subTitle ?? '',
          style: WEDIDTextStyle.nanumSquareNeoE.copyWith(fontSize: 12.sp)),
    );
  }

  SignUpNextArrowButton signUpNextButton(BuildContext context) {
    return SignUpNextArrowButton(
      onTap: nextButtonCallback,
      letter: letter ?? '',
      onLetterTap: letterCallback,
    );
  }
}

class SignUpNextArrowButton extends StatelessWidget {
  const SignUpNextArrowButton({required this.onTap,this.onLetterTap,this.letter = '', super.key});

  final VoidCallback onTap;
  final VoidCallback? onLetterTap;
  final String letter;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.network != current.network,
      builder: (context, state) {
        if (state.network == SignUpNetwork.loading) {
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

signUpErrorDialogHandler(BuildContext context, SignUpError error) {
  switch (error) {
    case SignUpError.emptyName:
      WEDIDConfirmDialog.confirmDialog(
        context: context,
        title: '잠시만요!',
        content: 'WEDID를 사용하려면 이름을 입력해야합니다.\n당신의 이름을 입력해 주세요.',
      );
      break;
    case SignUpError.wrongBirth:
      WEDIDConfirmDialog.confirmDialog(
          context: context, title: '다시 입력해 주세요', content: '입력한 날짜가 유효하지 않습니다.');
      break;
    case SignUpError.emptyGender:
      WEDIDConfirmDialog.confirmDialog(
          context: context, title: '다시 선택해 주세요', content: '성별을 아직 선택하지 않았습니다.');
      break;
    case SignUpError.networkError:
      WEDIDConfirmDialog.confirmDialog(
          context: context,
          title: '네트워크 에러 발생',
          content: '인터넷 연결을 확인 후 다시 시도하세요.');
      break;
    case SignUpError.inValidPhoneNumber:
      WEDIDConfirmDialog.confirmDialog(
          context: context, title: '다시 입력해 주세요', content: '올바르지 않은 핸드폰 번호입니다.');
      break;
    case SignUpError.notMatchCertNumber:
      WEDIDConfirmDialog.confirmDialog(
          context: context, title: '다시 입력해 주세요', content: '잘못된 인증 번호입니다.');
      break;
      /// Todo: 다시 보내드리는 로직이 필요할까? 글 수정하기?
    case SignUpError.inValidCertNumber:
      WEDIDConfirmDialog.confirmDialog(
          context: context,
          title: '다시 입력해 주세요',
          content: '보내드린 인증번호와 다르네요\n다시 보내드릴까요?');
      break;
    case SignUpError.expiredCertNumber:
      WEDIDConfirmDialog.confirmDialog(
          context: context,
          title: '다시 입력해 주세요',
          content: '보내드린 인증번호가 만료되었습니다\n다시 보내드릴까요?');
      break;
    case SignUpError.notExistCertNumber:
      WEDIDConfirmDialog.confirmDialog(
          context: context, title: '다시 입력해 주세요', content: '인증번호를 받지 않으셨습니다.');
      break;
    case SignUpError.existUser:
      WEDIDConfirmDialog.confirmDialog(
        context: context,
        title: '회원가입',
        content: '이미 가입하신 회원입니다.',
        callback: () {
          Navigator.of(context).pop(true);
          context.goNamed('signIn');
        },
      );
      break;
    case SignUpError.noError:
      break;
  }
}

Future<bool> textFieldConfirmCancelDialog({
  required BuildContext context,
  String? title,
  String? content,
  String? button,
}) async {
  context
      .read<DialogBloc>()
      .add((DialogInitEvent(title: title, content: content, button: button)));

  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final controller = TextEditingController();
      final origin = controller.value.text;

      void listener() {
        if (origin != controller.value.text) {
          context
              .read<DialogBloc>()
              .add(const ChangeButtonEvent(button: '중복체크'));
        }
      }

      return BlocConsumer<DialogBloc, DialogState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == DialogStatus.done) {
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) {
          final isOk = state.button == '확인';

          if (isOk) {
            controller.addListener(listener);
          } else {
            controller.removeListener(listener);
          }

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: AlertDialog(
              backgroundColor: WEDIDColor.w000000,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0.r)),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 60.w, vertical: 14.h),
              actionsPadding:
                  EdgeInsets.only(bottom: 22.h, right: 18.w, left: 18.w),
              actionsAlignment: MainAxisAlignment.center,
              title: Text(state.title,
                  textAlign: TextAlign.center,
                  style: WEDIDTextStyle.nanumSquareNeoE
                      .copyWith(fontSize: 20.sp, letterSpacing: -0.4)),
              content: SizedBox(
                height: 83.h,
                child: Column(
                  children: [
                    Expanded(
                      child: WEDIDTextField(
                        submitCallback: (val) {},
                        labelText: '닉네임',
                        controller: controller,
                        isCenter: true,
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: [WEDIDColor.w2AC870, WEDIDColor.w04FFFE],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds);
                      },
                      child: Text(
                        state.content,
                        textAlign: TextAlign.center,
                        style: WEDIDTextStyle.nanumSquareNeoE
                            .copyWith(fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('취소',
                              style: WEDIDTextStyle.nanumSquareNeoE.copyWith(
                                  fontSize: 14.sp,
                                  letterSpacing: -0.4,
                                  color: WEDIDColor.w000000)),
                        ),
                      ),
                    ),
                    SizedBox(width: 21.w),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (isOk) {
                              context.read<DialogBloc>().add(
                                  ChangeNickNameEvent(
                                      nickname: controller.value.text));
                            } else {
                              context.read<DialogBloc>().add(
                                  CheckNickNameDupEvent(
                                      nickname: controller.value.text));
                            }
                          },
                          child: Text(state.button,
                              style: WEDIDTextStyle.nanumSquareNeoE.copyWith(
                                  fontSize: 14.sp,
                                  letterSpacing: -0.4,
                                  color: WEDIDColor.w000000)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
