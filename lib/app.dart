import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:withapp_did/injection_container.dart';
import 'package:withapp_did/presentation/wedid_presentation.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));

    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(create: (context) => serviceLocator()..add(const SplashInitEvent())),
        BlocProvider<GoRouterBloc>(create: (context) => serviceLocator()),
      ],
      child: const MyAppView(),
    );
  }
}

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        useMaterial3: true,
      ),
      routerConfig: serviceLocator<GoRouter>(),
    );
  }
}
