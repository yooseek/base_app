import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:withapp_did/core/wedid_core.dart';

class WEDIDButton extends StatelessWidget {
  const WEDIDButton({
    required this.onClick,
    required this.text,
    required this.fontSize,
    this.isBlock = false,
    super.key,
  });

  final VoidCallback onClick;
  final String text;
  final double fontSize;
  final bool isBlock;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 345.w,
      height: 48.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: isBlock ? WEDIDColor.w0F0F0F : WEDIDColor.wFFFFFF),
        onPressed: onClick,
        child: Text(
          text,
          style: WEDIDTextStyle.nanumSquareNeoE.copyWith(
              color: isBlock ? WEDIDColor.wFFFFFF : WEDIDColor.w0F0F0F,
              fontWeight: FontWeight.w700,
              fontSize: fontSize),
        ),
      ),
    );
  }
}

class WEDIDTwoButton extends StatelessWidget {
  const WEDIDTwoButton({
    required this.onClickA,
    required this.onClickB,
    required this.textA,
    required this.textB,
    required this.fontSizeA,
    required this.fontSizeB,
    this.isBlock = false,
    super.key,
  });

  final VoidCallback onClickA;
  final VoidCallback onClickB;
  final String textA;
  final String textB;
  final double fontSizeA;
  final double fontSizeB;
  final bool isBlock;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 345.w,
      height: 48.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: isBlock ? WEDIDColor.w0F0F0F : WEDIDColor.wFFFFFF),
              onPressed: onClickA,
              child: Text(textA,
                  style: WEDIDTextStyle.nanumSquareNeoE.copyWith(
                      color: isBlock ? WEDIDColor.wFFFFFF : WEDIDColor.w0F0F0F, fontSize: fontSizeA)),
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: isBlock ? WEDIDColor.w0F0F0F : WEDIDColor.wFFFFFF),
              onPressed: onClickB,
              child: Text(textB,
                  style: WEDIDTextStyle.nanumSquareNeoE.copyWith(
                      color: isBlock ? WEDIDColor.wFFFFFF : WEDIDColor.w0F0F0F, fontSize: fontSizeB)),
            ),
          ),
        ],
      )
    );
  }
}

