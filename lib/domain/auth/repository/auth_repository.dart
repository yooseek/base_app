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
  Future<Either<Failure, String>> signUpAuth({required SignUpRequest request});
  Future<Either<Failure, String>> signOutAuth();
  Future<Either<Failure, bool>> getIsWatchOnBoard();
  Future<Either<Failure, bool>> setIsWatchOnBoard(bool isWatch);
  Future<Either<Failure, bool>> checkNickNameDup(String request);
  Future<Either<Failure, bool>> changeNickName(String request);
  Future<Either<Failure, NickNameListByPhoneResponse>> getNickNameList(String request);
  Future<Either<Failure, MatchNickNameResponse>> matchNickName(String phone,String nickname);
  Future<Either<Failure, bool>> changePhone(String oldPhone,String newPhone);
  Stream<AuthStatus> get getAuth;
  Stream<String> get getNickName;
}

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final TokenLocalDatabase tokenLocalDatabase;
  final OnBoardLocalDatabase onBoardLocalDatabase;
  final AuthAPI authAPI;
  final MemberAPI memberAPI;

  AuthRepositoryImpl({
    required this.networkInfo,
    required this.tokenLocalDatabase,
    required this.onBoardLocalDatabase,
    required this.authAPI,
    required this.memberAPI,
  }){
    authObserve = BehaviorSubject.seeded(AuthStatus.init);
    nickNameObserve = BehaviorSubject.seeded('');
  }

  late final BehaviorSubject<AuthStatus> authObserve;
  late final BehaviorSubject<String> nickNameObserve;

  @override
  Stream<AuthStatus> get getAuth => authObserve.stream;
  Sink<AuthStatus> get _setAuth => authObserve.sink;

  @override
  Stream<String> get getNickName => nickNameObserve.stream;
  Sink<String> get _setNickName => nickNameObserve.sink;

  @override
  Future<Either<Failure, String>> verifyPhone(PhoneAndCert request) async {
    if(await networkInfo.isConnected) {
      try{
        final verifyPhoneResponse = await authAPI.verifyPhoneCert(request: request);

        if(verifyPhoneResponse.data.runtimeType == bool) {
          /// 회원가입 안되어 있음

          return const Right('unAuth Success');
        }else{
          /// 회원가입 되어 있음
          final TokenResponse token = TokenResponse.fromJson(verifyPhoneResponse.data);

          tokenLocalDatabase.cachedAccessToken(token.accessToken);
          tokenLocalDatabase.cachedAccessToken(token.refreshToken);
          _setAuth.add(AuthStatus.auth);
        }

        return const Right('Auth Success');
      }on ServerException catch(_){
        return const Left(ServerFailure());
      }on CacheException catch(_){
        return const Left(CacheFailure());
      }on DioError catch(e){
        return WEDIDErrorHandler.networkErrorHandler(e);
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
      }on DioError catch(_){
        _setAuth.add(AuthStatus.unAuth);
        return const Left(ServerFailure());
      }
    }else {
      _setAuth.add(AuthStatus.unAuth);
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, String>> signUpAuth({required SignUpRequest request}) async {
    if(await networkInfo.isConnected) {
      try{
        final verifyPhoneResponse = await memberAPI.signUp(request: request);
        tokenLocalDatabase.cachedAccessToken(verifyPhoneResponse.data.token.accessToken);
        tokenLocalDatabase.cachedRefreshToken(verifyPhoneResponse.data.token.refreshToken);

        final nickName = verifyPhoneResponse.data.nickName;

        _setAuth.add(AuthStatus.auth);
        _setNickName.add(nickName);

        return const Right('SignUp Success');
      }on ServerException catch(_){
        return const Left(ServerFailure());
      }on CacheException catch(_){
        return const Left(CacheFailure());
      }on DioError catch(e){
        return WEDIDErrorHandler.networkErrorHandler(e);
      }
    }else {
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
        return WEDIDErrorHandler.networkErrorHandler(e);
      }
    }else {
      return const Left(NetworkFailure(msg: "Network Error"));
    }
  }

  @override
  Future<Either<Failure, bool>> getIsWatchOnBoard() async {
    try{
      final isWatch = await onBoardLocalDatabase.getIsWatchOnboard();

      return Right(isWatch);
    }on CacheException catch(e){
      return Left(CacheFailure(msg: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> setIsWatchOnBoard(bool isWatch) async {
    try{
      await onBoardLocalDatabase.cachedIsWatchOnboard(isWatch);

      return const Right(true);
    }on CacheException catch(e){
      return Left(CacheFailure(msg: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> changeNickName(String request) async {
    if(await networkInfo.isConnected) {
      try{
        await memberAPI.patchMemberUpdate(request: PatchMemberRequest(nickname: request));
        _setNickName.add(request);

        return const Right(true);
      }on ServerException catch(e){
        return Left(ServerFailure(msg: e.toString()));
      }on CacheException catch(e){
        return Left(CacheFailure(msg: e.toString()));
      }on DioError catch(e){
        return Left(ServerFailure(msg: e.toString()));
      }
    }else {
      return const Left(NetworkFailure(msg: "Network Error"));
    }
  }

  @override
  Future<Either<Failure, bool>> checkNickNameDup(String request) async {
    if(await networkInfo.isConnected) {
      try{
        final result = await memberAPI.nickNameDupCheck(request: request);

        return Right(result.data);
      }on ServerException catch(e){
        return Left(ServerFailure(msg: e.toString()));
      }on CacheException catch(e){
        return Left(CacheFailure(msg: e.toString()));
      }on DioError catch(e){
        return Left(ServerFailure(msg: e.toString()));
      }
    }else {
      return const Left(NetworkFailure(msg: "Network Error"));
    }
  }

  @override
  Future<Either<Failure, bool>> changePhone(String oldPhone, String newPhone) async {
    if(await networkInfo.isConnected) {
      try{
        final result = await memberAPI.memberPhoneChange(requestA: oldPhone,requestB: PhoneNumber(phoneNumber: newPhone));

        return Right(result.data);
      }on ServerException catch(e){
        return Left(ServerFailure(msg: e.toString()));
      }on CacheException catch(e){
        return Left(CacheFailure(msg: e.toString()));
      }on DioError catch(e){
        return WEDIDErrorHandler.networkErrorHandler(e);
      }
    }else {
      return const Left(NetworkFailure(msg: "Network Error"));
    }
  }

  @override
  Future<Either<Failure, NickNameListByPhoneResponse>> getNickNameList(String request) async {
    if(await networkInfo.isConnected) {
      try{
        final result = await memberAPI.nicknameListByPhoneNumber(request: request);

        return Right(result.data);
      }on ServerException catch(e){
        return Left(ServerFailure(msg: e.toString()));
      }on CacheException catch(e){
        return Left(CacheFailure(msg: e.toString()));
      }on DioError catch(e){
        return WEDIDErrorHandler.networkErrorHandler(e);
      }
    }else {
      return const Left(NetworkFailure(msg: "Network Error"));
    }
  }

  @override
  Future<Either<Failure, MatchNickNameResponse>> matchNickName(String phone, String nickname) async{
    if(await networkInfo.isConnected) {
      try{
        final result = await memberAPI.matchNickname(requestA: phone,requestB: nickname);

        return Right(result.data);
      }on ServerException catch(e){
        return Left(ServerFailure(msg: e.toString()));
      }on CacheException catch(e){
        return Left(CacheFailure(msg: e.toString()));
      }on DioError catch(e){
        return WEDIDErrorHandler.networkErrorHandler(e);
      }
    }else {
      return const Left(NetworkFailure(msg: "Network Error"));
    }
  }
}