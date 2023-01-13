import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:withapp_did/injection_container.dart';
import 'package:withapp_did/presentation/signin/signIn_presentation.dart';

class SigninProvider extends StatelessWidget {
  const SigninProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SigninBloc>(
      create: (context) => serviceLocator(),
      child: const SigninView(),
    );
  }
}
