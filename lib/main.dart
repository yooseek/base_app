import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:withapp_did/app.dart';
import 'package:withapp_did/injection_container.dart';

void main() async {
  await initializeDependencies();
  await ScreenUtil.ensureScreenSize();
  runApp(const MyApp());
}