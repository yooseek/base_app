import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:withapp_did/injection_container.dart';
import 'package:withapp_did/presentation/home/home_presentation.dart';

class HomeProvider extends StatelessWidget {
  const HomeProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => serviceLocator(),
      child: const HomeView(),
    );
  }
}
