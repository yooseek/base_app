import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:withapp_did/core/wedid_core.dart';

typedef SubmitCallback = void Function(String val);

class WEDIDTextField extends StatefulWidget {
  const WEDIDTextField({
    required this.labelText,
    this.keyboardType = TextInputType.text,
    required this.submitCallback,
    required this.controller,
    this.focusNode,
    this.isCenter = false,
    this.isBoarder = true,
    super.key,
  });

  final String labelText;
  final TextInputType keyboardType;
  final SubmitCallback submitCallback;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool isCenter;
  final bool isBoarder;

  @override
  State<WEDIDTextField> createState() => _WEDIDTextFieldState();
}

class _WEDIDTextFieldState extends State<WEDIDTextField> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: widget.isCenter ? TextAlign.center : TextAlign.start,
      focusNode: widget.focusNode,
      controller: widget.controller,
      autofocus: true,
      style: WEDIDTextStyle.nanumSquareNeoE.copyWith(leadingDistribution: TextLeadingDistribution.even,fontSize: 18.sp),
      cursorColor: WEDIDColor.wFFFFFF,
      cursorHeight: 24.h,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        fillColor: WEDIDColor.w222222,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: widget.isBoarder ? WEDIDColor.w484848 : Colors.transparent, width: widget.isBoarder ? 1 : 0),
          gapPadding: 0,
        ),
        enabledBorder: widget.isBoarder ? null : OutlineInputBorder(
          borderSide: BorderSide(color: widget.isBoarder ? WEDIDColor.w484848 : Colors.transparent, width: widget.isBoarder ? 1 : 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: widget.isBoarder ? WEDIDColor.w484848 : Colors.transparent, width: widget.isBoarder ? 1 : 0),
          gapPadding: 0,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
        labelText: widget.labelText,
        labelStyle: WEDIDTextStyle.nanumSquareNeoE.copyWith(
          leadingDistribution: TextLeadingDistribution.even,
            fontSize: 18.sp, letterSpacing: -0.4, color: WEDIDColor.w484848),
      ),
      onSubmitted: widget.submitCallback,
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
    if(widget.focusNode != null){
      widget.focusNode!.dispose();
    }
  }
}