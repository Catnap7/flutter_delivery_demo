import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_study_2/common/model/cursor_pagination_model.dart';
import 'package:flutter_study_2/common/model/pagination_params.dart';
import 'package:flutter_study_2/rating/model/rating_model.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_rating_repository.g.dart';

// http://ip/restaurnt/:rid/rating
@RestApi()
abstract class RestaurantRatingRepository {
  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) =
      _RestaurantRatingRepository;

  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RatingModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}
