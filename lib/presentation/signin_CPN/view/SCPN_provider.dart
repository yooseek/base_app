import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:withapp_did/injection_container.dart';

import 'package:withapp_did/presentation/signin_CPN/signin_CPN_presentation.dart';

class SigninChangePhoneNumberProvider extends StatelessWidget {
  const SigninChangePhoneNumberProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SCPNBloc>(
      create: (context) => serviceLocator(),
      child: const SignInChangePhoneNumberView(),
    );
  }
}
