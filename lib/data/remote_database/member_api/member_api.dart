import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';

import 'package:withapp_did/core/wedid_core.dart';
import 'package:withapp_did/data/wedid_data.dart';
import 'package:withapp_did/domain/wedid_domain.dart';

part 'member_api.g.dart';

@RestApi()
abstract class MemberAPI {
  factory MemberAPI(Dio dio, {String baseUrl}) = _MemberAPI;

  @POST('/sign-up')
  @Headers({'accessToken': 'true'})
  Future<WEDIDResponse<SignUpResponse>> signUp({@Body() required SignUpRequest request});

  @GET('/{nickname}/duplicate')
  @Headers({'accessToken': 'true'})
  Future<WEDIDResponse<bool>> nickNameDupCheck({@Path('nickname') required String request});

  @PATCH('/')
  @Headers({'accessToken': 'true'})
  Future<WEDIDResponse<bool>> patchMemberUpdate({@Body() required PatchMemberRequest request});

  @GET('/{phone}/nickname-list')
  Future<WEDIDResponse<NickNameListByPhoneResponse>> nicknameListByPhoneNumber({@Path('phone') required String request});

  @GET('/{phone}/{nickname}')
  Future<WEDIDResponse<MatchNickNameResponse>> matchNickname({@Path('phone') required String requestA,@Path('nickname') required String requestB});

  @PATCH('/{phone}')
  Future<WEDIDResponse<bool>> memberPhoneChange({@Path('phone') required String requestA,@Body() required PhoneNumber requestB});
}
