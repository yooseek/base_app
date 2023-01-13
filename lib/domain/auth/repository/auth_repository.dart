import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import 'package:withapp_did/core/wedid_core.dart';
import 'package:withapp_did/data/wedid_data.dart';
import 'package:withapp_did/domain/wedid_domain.dart';

enum AuthStatus {
  init,
  auth,
  unAuth,
  error
}

abstract class AuthRepository{
  Future<Either<Failure, String>> verifyPhone(PhoneAndCert request);
  Future<Either<Failure, String>> getPhoneCert(PhoneNumber request);
  Future<Either<Failure, String>> checkAuth();
  Future<Either<Failure, String>> signOutAuth();
  Stream<AuthStatus> get getAuth;
}

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final TokenLocalDatabase tokenLocalDatabase;
  final AuthAPI authAPI;

  AuthRepositoryImpl({
    required this.networkInfo,
    required this.tokenLocalDatabase,
    required this.authAPI,
  }){
    authObserve = BehaviorSubject.seeded(AuthStatus.init);
  }

  late final BehaviorSubject<AuthStatus> authObserve;

  @override
  Stream<AuthStatus> get getAuth => authObserve.stream;
  Sink<AuthStatus> get _setAuth => authObserve.sink;

  @override
  Future<Either<Failure, String>> verifyPhone(PhoneAndCert request) async {
    if(await networkInfo.isConnected) {
      try{
        final verifyPhoneResponse = await authAPI.verifyPhoneCert(request: request);
        tokenLocalDatabase.cachedAccessToken(verifyPhoneResponse.data.accessToken);
        tokenLocalDatabase.cachedRefreshToken(verifyPhoneResponse.data.refreshToken);

        _setAuth.add(AuthStatus.auth);

        return const Right('Verify Success');
      }on ServerException catch(_){
        return const Left(ServerFailure());
      }on CacheException catch(_){
        return const Left(CacheFailure());
      }on DioError catch(e){
        switch(WEDIDError.fromJson(jsonDecode(e.response.toString())).status) {
          case 10001:
            ///VERIFICATION_CODE_ERROR
            ///인증 번호 불일치
            return const Left(ServerFailure(msg: "10001"));
          case 10004:
            ///CERT_NUMBER_EXPIRED
            ///인증 번호 만료
            return const Left(ServerFailure(msg: "10004"));
          case 10005:
            ///CERT_NOT_FOUND
            ///인증 번호 존재하지 않음
            return const Left(ServerFailure(msg: "10005"));
          case 30001:
            ///MEMBER_NOT_FOUND
            ///회원 정보 없음
            return const Left(ServerFailure(msg: "30001"));
        }

        return const Left(ServerFailure());
      }
    }else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, String>> checkAuth() async {
    if(await networkInfo.isConnected) {
      try{
        final refresh = await tokenLocalDatabase.getRefreshToken();

        final tokenResponse = await authAPI.refreshToken(request: RefreshToken(refreshToken: refresh));

        tokenLocalDatabase.cachedAccessToken(tokenResponse.data.accessToken);
        tokenLocalDatabase.cachedRefreshToken(tokenResponse.data.refreshToken);

        _setAuth.add(AuthStatus.auth);

        return const Right('CheckAuth Success');
      }on ServerException catch(_){
        _setAuth.add(AuthStatus.unAuth);
        return const Left(ServerFailure());
      }on CacheException catch(_){
        _setAuth.add(AuthStatus.unAuth);
        return const Left(CacheFailure());
      }on DioError catch(e){
        _setAuth.add(AuthStatus.unAuth);
        return const Left(ServerFailure());
      }
    }else {
      _setAuth.add(AuthStatus.unAuth);
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, String>> signOutAuth() async {
    try{
      await tokenLocalDatabase.deleteToken();

      _setAuth.add(AuthStatus.unAuth);

      return const Right('SignOut Success');
    }on CacheException catch(e){
      return Left(CacheFailure(msg: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getPhoneCert(PhoneNumber request) async {
    if(await networkInfo.isConnected) {
      try{
        await authAPI.getPhoneCert(request: request);

        return const Right('GetPhoneCert Success');
      }on ServerException catch(e){
        return Left(ServerFailure(msg: e.toString()));
      }on CacheException catch(e){
        return Left(CacheFailure(msg: e.toString()));
      }on DioError catch(e){
        switch(WEDIDError.fromJson(jsonDecode(e.response.toString())).status) {
          case 30001:
          ///MEMBER_NOT_FOUND
          ///회원 정보 없음
            return const Left(ServerFailure(msg: "30001"));
        }

        return Left(ServerFailure(msg: e.toString()));
      }
    }else {
      return const Left(NetworkFailure(msg: "Network Error"));
    }
  }
}