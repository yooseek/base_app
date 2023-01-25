import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:withapp_did/injection_container.dart';
import 'package:withapp_did/core/wedid_core.dart';
import 'package:withapp_did/presentation/wedid_presentation.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(create: (context) => serviceLocator()..add(const SplashInitEvent())),
        BlocProvider<GoRouterBloc>(create: (context) => serviceLocator()),
        BlocProvider<DialogBloc>(create: (context) => serviceLocator()),
      ],
      child: const MyAppView(),
    );
  }
}

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          scrollBehavior: MyCustomScrollBehavior(),
          theme: WEDIDTheme(),
          routerConfig: serviceLocator<GoRouter>(),
        );
      },
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(context, child,details) {
    return child;
  }
}
