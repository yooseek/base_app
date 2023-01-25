import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:withapp_did/core/wedid_core.dart';
import 'package:withapp_did/presentation/wedid_presentation.dart';

class OnboardView extends StatelessWidget {
  OnboardView({super.key});

  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardBloc, OnboardState>(
      listenWhen: (previous, current) => previous.isWatch != current.isWatch,
      listener: (context, state) {
        if (state.isWatch != null && state.isWatch!) {
          pageController.animateToPage(3,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn);
        }
      },
      builder: (context, state) {
        final isLast = state.isLast;

        return WEDIDScaffold(
          appbar: onboardAppBar(isLast),
          child: OnboardPageWidget(pageController: pageController),
        );
      },
    );
  }

  WEDIDAppBar onboardAppBar(bool isLast) {
    return WEDIDAppBar(
      title: 'WEDID',
      actions: [
        if (!isLast)
          TextButton(
            onPressed: () {
              pageController.animateToPage(3,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn);
            },
            child: Text(
              '건너뛰기',
              style: WEDIDTextStyle.nanumSquareNeoE.copyWith(
                fontSize: 14.sp,
                color: WEDIDColor.w484848,
              ),
            ),
          ),
      ],
    );
  }
}

class OnboardPageWidget extends StatefulWidget {
  const OnboardPageWidget({
    required this.pageController,
    super.key,
  });

  final PageController pageController;

  @override
  State<OnboardPageWidget> createState() => _OnboardPageWidgetState();
}

class _OnboardPageWidgetState extends State<OnboardPageWidget> {
  PageController get pageController => widget.pageController;
  bool isLastPage = false;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            onPageChanged: (index) {
              setState(() {
                isLastPage = index == 3;
                context
                    .read<OnboardBloc>()
                    .add(OnboardLastPageEvent(isLast: isLastPage));
              });
            },
            physics: const ClampingScrollPhysics(),
            controller: pageController,
            children: [
              Container(
                color: Colors.white,
                child: Center(child: Text('page 1')),
              ),
              Container(
                color: Colors.white,
                child: Center(child: Text('page 2')),
              ),
              Container(
                color: Colors.white,
                child: Center(child: Text('page 3')),
              ),
              Container(
                color: Colors.white,
                child: Center(child: Text('page 4')),
              ),
            ],
          ),
        ),
        pageIndicator(),
        SizedBox(height: 25.h),
        nextAndSignButton(),
        SizedBox(height: 8.h),
        Text('서비스 시작시 이용약관/개인정보 처리방침 동의로 간주합니다.',
            style: WEDIDTextStyle.nanumSquareNeoE.copyWith(
                color: WEDIDColor.w7C7C7C,
                height: 31.h / 12.sp,
                fontSize: 12.sp,
                letterSpacing: -0.4)),
        SizedBox(height: 41.h),
      ],
    );
  }

  Future<void> requestPermission(List<Permission> permissions,VoidCallback success) async {
    Map<Permission, PermissionStatus> statuses = await permissions.request();

    final status = statuses[permissions[0]] ?? PermissionStatus.denied;

    switch(status){
      case PermissionStatus.denied:
        openAppSettings();
        break;
      case PermissionStatus.granted:
        success();
        break;
      case PermissionStatus.restricted:
        success();
        break;
      case PermissionStatus.limited:
        break;
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
        break;
    }
  }

  Widget nextAndSignButton() {
    if (isLastPage) {
      return WEDIDTwoButton(
        onClickA: () {
          wedidPermissionBottomSheet(
              context: context,
              keepGoing: () async {
                context.read<OnboardBloc>().add(const OnboardWatchEvent());
                await requestPermission([Permission.camera],(){context.goNamed('signUp');});
              });
        },
        onClickB: () {
          wedidPermissionBottomSheet(
              context: context,
              keepGoing: () async {
                context.read<OnboardBloc>().add(const OnboardWatchEvent());
                await requestPermission([Permission.camera],(){context.goNamed('signIn');});
              });
        },
        textA: '회원가입',
        textB: '로그인',
        fontSizeA: 14.sp,
        fontSizeB: 14.sp,
      );
    } else {
      return WEDIDButton(
        onClick: () {
          pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        },
        text: '다음',
        fontSize: 14.sp,
      );
    }
  }

  Padding pageIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: SmoothPageIndicator(
        controller: pageController,
        count: 4,
        effect: WormEffect(
            dotHeight: 8.h,
            dotWidth: 8.h,
            dotColor: WEDIDColor.w3E3E3E,
            activeDotColor: WEDIDColor.wFFFFFF),
        onDotClicked: (index) {
          pageController.animateToPage(index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn);
        },
      ),
    );
  }

  wedidPermissionBottomSheet(
      {required BuildContext context, required VoidCallback keepGoing}) async {
    return showBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(24.r), topLeft: Radius.circular(24.r))),
      builder: (context) {
        return Container(
          height: 426.h,
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(24.r),
                topLeft: Radius.circular(24.r)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 29.h),
              Text(
                'WEDID를 시작하려면 권한이 필요해요',
                textAlign: TextAlign.center,
                style: WEDIDTextStyle.nanumSquareNeoE.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: WEDIDColor.w0F0F0F,
                  letterSpacing: -0.4,
                ),
              ),
              SizedBox(height: 29.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        colors: [WEDIDColor.w2AC870, WEDIDColor.w04FFFE],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Image.asset(WEDIDImage.notificationIcon),
                  ),
                  SizedBox(width: 8.w),
                  SizedBox(
                    width: 265.w,
                    height: 71.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '알림',
                            style: WEDIDTextStyle.nanumSquareNeoE.copyWith(color: WEDIDColor.w0F0F0F,height:20.5.h/14.sp, fontSize: 16.sp),
                        ),
                        Text(
                          '대회 정보나 앱 공지사항 등 다양한 정보에 대해 알려드려요.',
                          style: WEDIDTextStyle.nanumSquareNeoC.copyWith(color: WEDIDColor.w848484, fontSize: 14.sp,height:20.5.h/14.sp,letterSpacing: -0.4),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 34.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 28,
                    width: 28,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        colors: [WEDIDColor.w2AC870, WEDIDColor.w04FFFE],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Image.asset(WEDIDImage.cameraIcon),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('카메라',
                          style: WEDIDTextStyle.nanumSquareNeoE.copyWith(
                              color: WEDIDColor.w0F0F0F, fontSize: 16.sp)),
                      Text('QR 인식을 위해 카메라를 사용해요.',style: WEDIDTextStyle.nanumSquareNeoC.copyWith(
                      color: WEDIDColor.w848484, fontSize: 14.sp)),
                    ],
                  )
                ],
              ),
              SizedBox(height: 15.h),
              Container(
                margin: EdgeInsets.only(left: 28 + 8.w),
                child: Text('개인정보 처리 방침 >',style: WEDIDTextStyle.nanumSquareNeoC.copyWith(
                    color: WEDIDColor.w848484, fontSize: 14.sp)),
              ),
              const Spacer(),
              WEDIDButton(
                  onClick: keepGoing,
                  text: '계속하기',
                  fontSize: 14.sp,
                  isBlock: true),
              SizedBox(height: 72.h)
            ],
          ),
        );
      },
    );
  }
}
