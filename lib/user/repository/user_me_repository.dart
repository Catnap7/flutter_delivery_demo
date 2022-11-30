import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/common/const/data.dart';
import 'package:flutter_study_2/common/dio/dio.dart';
import 'package:flutter_study_2/user/model/basket_item_model.dart';
import 'package:flutter_study_2/user/model/patch_basket_body.dart';
import 'package:flutter_study_2/user/model/user_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_me_repository.g.dart';

final userMeRepositoryProvider = Provider<UserMeRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return UserMeRepository(dio, baseUrl: 'http://$ip/user');
});

//http://$ip/user/me
@RestApi()
abstract class UserMeRepository {
  factory UserMeRepository(Dio dio, {String? baseUrl}) = _UserMeRepository;

  @GET('/me')
  @Headers({
    'accessToken': 'true',
  })
  Future<UserModel> getMe();

  @GET('/basket')
  @Headers({
    'accessToken': 'true',
  })
  Future<List<BasketItemModel>> getBasket();

  @PATCH('/me/basket')
  @Headers({
    'accessToken': 'true',
  })
  Future<List<BasketItemModel>> patchBasket({
    // PatchBasketBody가 toJson이 실행되면서 Body 값으로 변경된 후 실행된다
    @Body() required PatchBasketBody basket,
  });



}
