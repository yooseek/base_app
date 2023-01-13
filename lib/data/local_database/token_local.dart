import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:withapp_did/core/wedid_core.dart';

abstract class TokenLocalDatabase {
  Future<String> getAccessToken();
  Future<String> getRefreshToken();
  Future<void> deleteToken();

  Future<void> cachedAccessToken(String accessToken);
  Future<void> cachedRefreshToken(String refreshToken);
}

class TokenLocalDatabaseImpl implements TokenLocalDatabase {
  final FlutterSecureStorage secureStorage;
  const TokenLocalDatabaseImpl({required this.secureStorage});

  @override
  Future<void> cachedAccessToken(String accessToken) async {
    await secureStorage.write(key: accessTokenKey, value: accessToken);
  }

  @override
  Future<void> cachedRefreshToken(String refreshToken) async {
    await secureStorage.write(key: refreshTokenKey, value: refreshToken);
  }

  @override
  Future<String> getAccessToken() async {
    final token = await secureStorage.read(key: accessTokenKey);
    if(token == null) {
      throw CacheException();
    }else{
      return token;
    }
  }

  @override
  Future<String> getRefreshToken() async {
    final token = await secureStorage.read(key: refreshTokenKey);
    if(token == null) {
      throw CacheException();
    }else{
      return token;
    }
  }

  @override
  Future<void> deleteToken() async {
    await Future.wait([
      secureStorage.delete(key: refreshTokenKey),
      secureStorage.delete(key: accessTokenKey),
    ]);
  }
}