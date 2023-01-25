import 'package:flutter/material.dart';

import 'package:withapp_did/core/wedid_core.dart';

ThemeData WEDIDTheme() {
  return ThemeData(
    useMaterial3: true,
    primarySwatch: Colors.blue,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    textTheme: TextTheme(bodyText1: WEDIDTextStyle.nanumSquareNeoD),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(WEDIDColor.wFFFFFF),
        overlayColor: MaterialStateProperty.all<Color>(WEDIDColor.wFFFFFF),
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
        shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      ),
    ),
  );
}
