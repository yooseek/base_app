// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _MemberAPI implements MemberAPI {
  _MemberAPI(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<WEDIDResponse<SignUpResponse>> signUp({required request}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'accessToken': 'true'};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WEDIDResponse<SignUpResponse>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/sign-up',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = WEDIDResponse<SignUpResponse>.fromJson(
      _result.data!,
      (json) => SignUpResponse.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<WEDIDResponse<bool>> nickNameDupCheck({required request}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'accessToken': 'true'};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WEDIDResponse<bool>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/${request}/duplicate',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = WEDIDResponse<bool>.fromJson(
      _result.data!,
      (json) => json as bool,
    );
    return value;
  }

  @override
  Future<WEDIDResponse<bool>> patchMemberUpdate({required request}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'accessToken': 'true'};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WEDIDResponse<bool>>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = WEDIDResponse<bool>.fromJson(
      _result.data!,
      (json) => json as bool,
    );
    return value;
  }

  @override
  Future<WEDIDResponse<NickNameListByPhoneResponse>> nicknameListByPhoneNumber(
      {required request}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WEDIDResponse<NickNameListByPhoneResponse>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/${request}/nickname-list',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = WEDIDResponse<NickNameListByPhoneResponse>.fromJson(
      _result.data!,
      (json) =>
          NickNameListByPhoneResponse.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<WEDIDResponse<MatchNickNameResponse>> matchNickname({
    required requestA,
    required requestB,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WEDIDResponse<MatchNickNameResponse>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/${requestA}/${requestB}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = WEDIDResponse<MatchNickNameResponse>.fromJson(
      _result.data!,
      (json) => MatchNickNameResponse.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<WEDIDResponse<bool>> memberPhoneChange({
    required requestA,
    required requestB,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(requestB.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WEDIDResponse<bool>>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/${requestA}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = WEDIDResponse<bool>.fromJson(
      _result.data!,
      (json) => json as bool,
    );
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
