import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:withapp_did/injection_container.dart';

import 'package:withapp_did/presentation/onboard/onboard_presentation.dart';

class OnboardProvider extends StatelessWidget {
  const OnboardProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardBloc>(
      create: (context) => serviceLocator()..add(const OnboardInitEvent()),
      child: OnboardView(),
    );
  }
}
