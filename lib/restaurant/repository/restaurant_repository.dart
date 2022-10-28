import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_study_2/common/model/cursor_pagination_model.dart';
import 'package:flutter_study_2/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_study_2/restaurant/model/restaurant_model.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

/*

  인스턴스화 안되게 abstract를 붙였음.
  final resp = await dio.get(
  'http://$ip/restaurant/$id',
  options: Options(
  headers: {
  'authorization': 'Bearer $accessToken',
  },
  ),
  );
  return resp.data;
  위 코드의 자동화를 위한 파일이며 레트로핏으로 구현함.

*/

@RestApi()
abstract class RestaurantRepository {
  // http://$ip/restaurant
  factory RestaurantRepository(Dio dio,{String baseUrl})
  = _RestaurantRepository;

  // 레스토랑 스크린에서 데이터 받아오는 함수기 떄문에 이름이 페이지네이션
  // http://$ip/restaurantf
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RestaurantModel>> paginate();


  // http://$ip/restaurant/:id/
  @GET('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    // Path의 id값을 자동으로 넣어줌
    @Path() required String id,
});



}