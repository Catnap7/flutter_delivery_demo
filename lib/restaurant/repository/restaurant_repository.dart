import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/common/const/data.dart';
import 'package:flutter_study_2/common/dio/dio.dart';
import 'package:flutter_study_2/common/model/cursor_pagination_model.dart';
import 'package:flutter_study_2/common/model/pagination_params.dart';
import 'package:flutter_study_2/common/reposiroty/base_pagination_repository.dart';
import 'package:flutter_study_2/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_study_2/restaurant/model/restaurant_model.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    final repository = RestaurantRepository(
      dio,
      baseUrl: 'http://$ip/restaurant',
    );
    return repository;
  },
);

@RestApi()
abstract class RestaurantRepository implements IBasePaginationRepository<RestaurantModel> {
  // http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  // 레스토랑 스크린에서 데이터 받아오는 함수기 떄문에 이름이 페이지네이션
  // http://$ip/restaurantf
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RestaurantModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
});

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
