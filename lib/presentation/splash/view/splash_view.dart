import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:withapp_did/presentation/wedid_presentation.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashAuth) {
          context.goNamed('home');
          return;
        } else if (state is SplashUnAuth) {
          context.goNamed('signIn');
          return;
        } else if (state is SplashError) {
          context.goNamed('splash');
          return;
        } else {
          context.goNamed('splash');
          return;
        }
      },
      child: Scaffold(
        body: Center(
          child: Text('splash'),
        ),
      ),
    );
  }
}
