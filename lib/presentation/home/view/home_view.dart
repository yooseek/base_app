import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:withapp_did/injection_container.dart';
import 'package:withapp_did/core/wedid_core.dart';
import 'package:withapp_did/data/wedid_data.dart';
import 'package:withapp_did/domain/wedid_domain.dart';
import 'package:withapp_did/presentation/wedid_presentation.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        return WEDIDScaffold(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('home',style: WEDIDTextStyle.nanumSquareNeoE),
                SizedBox(height: 100),
                TextButton(child: Text('로그아웃'), onPressed: () {
                  serviceLocator<AuthRepository>().signOutAuth();

                }),
                TextButton(child: Text('토큰 테스트'), onPressed: () {
                  serviceLocator<AuthAPI>().test();
                })
              ],
            ),
          ),
        );
      },
    );
  }
}
