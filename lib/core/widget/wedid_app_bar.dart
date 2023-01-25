import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:withapp_did/core/wedid_core.dart';

class WEDIDAppBar extends StatelessWidget implements PreferredSizeWidget{
  const WEDIDAppBar({
    required this.title,
    this.leading,
    this.actions,
    super.key,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        leading: leading,
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [WEDIDColor.w2AC870, WEDIDColor.w04FFFE],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          child: Text(
            title,
            style: WEDIDTextStyle.nanumSquareNeoE.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 30.sp,
              letterSpacing: -0.465,
              leadingDistribution: TextLeadingDistribution.even,
            ),
          ),
        ),
        actions: actions);
  }

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);
}
