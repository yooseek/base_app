import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:withapp_did/presentation/wedid_presentation.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, SignupState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: TextButton(child: Text('회원 가입'),onPressed: (){}),
          ),
        );
      },

    );
  }
}
