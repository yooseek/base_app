import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';

import 'package:withapp_did/core/network/wedid_response.dart';
import 'package:withapp_did/data/remote_database/auth_api/auth_data.dart';
import 'package:withapp_did/domain/auth/auth_domain.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthAPI {
  factory AuthAPI(Dio dio, {String baseUrl}) = _AuthAPI;

  @POST('/verify')
  Future<WEDIDResponse<dynamic>> verifyPhoneCert({@Body() required PhoneAndCert request});

  @PUT('/cert')
  Future<WEDIDResponse<bool>> getPhoneCert({@Body() required PhoneNumber request});

  @POST('/refresh')
  Future<WEDIDResponse<TokenResponse>> refreshToken({@Body() required RefreshToken request});

  @GET('/token-test')
  @Headers({'accessToken': 'true'})
  Future<WEDIDResponse<String>> test();
}