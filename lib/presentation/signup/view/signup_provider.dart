import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:withapp_did/injection_container.dart';
import 'package:withapp_did/presentation/wedid_presentation.dart';

class SignupProvider extends StatelessWidget {
  const SignupProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupBloc>(
      create: (context) => serviceLocator(),
      child: const SignupView(),
    );
  }
}
