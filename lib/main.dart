import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:withapp_did/app.dart';
import 'package:withapp_did/injection_container.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  await hiveConfig();
  await initializeDependencies();
  runApp(const MyApp());
}

Future<void> hiveConfig() async {
  await Hive.initFlutter();
}