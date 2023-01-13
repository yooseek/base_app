import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:withapp_did/presentation/wedid_presentation.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigninBloc,SigninState>(
      listenWhen: (previous, current) => previous.errorStatus != current.errorStatus || previous.certNumber != current.certNumber,
      listener: (context, state) {
        if(state.certNumber != null) {
          context.goNamed('home');
          return;
        }

        switch (state.errorStatus){
          case SignInErrorStatus.noMember :
            print('멤버 없음');
            break;
          case SignInErrorStatus.notExist :
            print('존재 안함');
            break;
          case SignInErrorStatus.expired :
            print('만료됨');
            break;
          case SignInErrorStatus.verifiedError :
            print('인증번호 틀림');
            break;
          case SignInErrorStatus.networkError :
            print('네트워크 연결안됨');
            break;
          case SignInErrorStatus.error :
            print('알 수 없는 오류 발생');
            break;
          default :
            break;
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    onSubmitted: (val){
                      context.read<SigninBloc>().add(GetCertNumber(phoneNumber: val));
                    },
                  ),
                  TextField(
                    onSubmitted: (val){
                      context.read<SigninBloc>().add(VerifyPhoneCert(certNumber: val));
                    },
                  )
                ],
              )
          ),
        );
      },
    );
  }
}
