import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:withapp_did/core/wedid_core.dart';

class WEDIDErrorHandler {
  static Either<Failure,T> networkErrorHandler<T>(DioError error) {
    final errorCode = WEDIDError.fromJson(jsonDecode(error.response.toString())).status;

    return Left(ServerFailure(msg: '$errorCode',error: NetworkErrorCategory.error(errorCode)));
  }
}

enum NetworkErrorCategory {
  networkError,
  verificationCodeError,
  certNumberTooManyTry,
  certNumberExpired,
  certNotFound,
  memberNotFoundException,
  memberDuplicateException,
  memberPhoneChangeTooManyException,
  memberNotFound;

  int code() {
    switch(this){
      case NetworkErrorCategory.networkError:
        return 10000;
    ///VERIFICATION_CODE_ERROR
    ///인증 번호 불일치
      case NetworkErrorCategory.verificationCodeError:
        return 10001;
    ///CERT_NUMBER_TOO_MANY_TRY
    ///시도 횟수 초과
      case NetworkErrorCategory.certNumberTooManyTry:
        return 10003;
    ///CERT_NUMBER_EXPIRED
    ///인증 번호 만료
      case NetworkErrorCategory.certNumberExpired:
        return 10004;
    ///CERT_NOT_FOUND
    ///인증 번호 존재하지 않음
      case NetworkErrorCategory.certNotFound:
        return 10006;
    ///MEMBER_NOT_FOUND_EXCEPTION
    ///회원 정보 없음
      case NetworkErrorCategory.memberNotFoundException:
        return 20001;
    ///MEMBER_DUPLICATE_EXCEPTION
    ///이미 가입한 회원
      case NetworkErrorCategory.memberDuplicateException:
        return 20004;
    ///MEMBER_PHONE_CHANGE_TOO_MANY_EXCEPTION
    ///닉네임 인증 횟수 초과
      case NetworkErrorCategory.memberPhoneChangeTooManyException:
        return 20009;
    ///MEMBER_NOT_FOUND - Deprecated
    ///회원 정보 없음
      case NetworkErrorCategory.memberNotFound: // Deprecated
        return 30001;
    }
  }

  static NetworkErrorCategory error(int code) {
    switch(code){
      case 10001:
        return NetworkErrorCategory.verificationCodeError;
      case 10003:
        return NetworkErrorCategory.certNumberTooManyTry;
      case 10004:
        return NetworkErrorCategory.certNumberExpired;
      case 10006:
        return NetworkErrorCategory.certNotFound;
      case 20001:
        return NetworkErrorCategory.memberNotFoundException;
      case 20004:
        return NetworkErrorCategory.memberDuplicateException;
      case 20009:
        return NetworkErrorCategory.memberPhoneChangeTooManyException;
      case 30001: // Deprecated
        return NetworkErrorCategory.memberNotFound;
      default :
        return NetworkErrorCategory.networkError;
    }
  }
}