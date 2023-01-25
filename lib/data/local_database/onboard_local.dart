import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:withapp_did/core/wedid_core.dart';

const String isWatchOnBoard = 'IS_WATCH_ON_BOARD';

abstract class OnBoardLocalDatabase {
  Future<bool> getIsWatchOnboard();
  Future<void> cachedIsWatchOnboard(bool isWatch);
  Future<void> deleteToken();
}

class OnBoardLocalDatabaseImpl implements OnBoardLocalDatabase {
  final HiveInterface hive;
  const OnBoardLocalDatabaseImpl({required this.hive});

  @override
  Future<void> cachedIsWatchOnboard(bool isWatch) async {
    final box = await hive.openBox(isWatchOnBoard);
    await box.put('key',isWatch);

    if(box.values.isEmpty){
      throw CacheException();
    }
  }

  @override
  Future<void> deleteToken() async {
    await hive.deleteBoxFromDisk(isWatchOnBoard);
  }

  @override
  Future<bool> getIsWatchOnboard() async {
    final box = await hive.openBox(isWatchOnBoard);
    if(box.values.isEmpty){
      return false;
    }

    final isWatch = box.get('key');
    return isWatch;
  }
}