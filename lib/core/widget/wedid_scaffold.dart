import 'package:flutter/material.dart';

import 'package:withapp_did/core/wedid_core.dart';

class WEDIDScaffold extends StatelessWidget {
  const WEDIDScaffold({required this.child,this.appbar,super.key});

  final Widget child;
  final PreferredSizeWidget? appbar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: WEDIDColor.w434343,
      appBar: appbar,
      body: child,
    );
  }
}
