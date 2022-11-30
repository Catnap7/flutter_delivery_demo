import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/common/const/data.dart';
import 'package:flutter_study_2/common/dio/dio.dart';
import 'package:flutter_study_2/common/model/cursor_pagination_model.dart';
import 'package:flutter_study_2/common/model/pagination_params.dart';
import 'package:flutter_study_2/common/reposiroty/base_pagination_repository.dart';
import 'package:flutter_study_2/order/model/order_model.dart';
import 'package:flutter_study_2/order/model/post_order_body.dart';
import 'package:retrofit/http.dart';


part 'order_repository.g.dart';

final orderRepository = Provider<OrderRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    return OrderRepository(dio, baseUrl: 'http://$ip/order');
  },
);

// http://$ip/order
@RestApi()
abstract class OrderRepository implements IBasePaginationRepository<OrderModel>{
  // TODO 팩토리란 무엇인가?
  factory OrderRepository(Dio dio, {String baseUrl}) = _OrderRepository;

  @GET('/')
  @Headers({
    'accessToken' : 'true',
  })
  Future<CursorPagination<OrderModel>> paginate({
   @Queries() PaginationParams? paginationParams = const PaginationParams(),
});

  @POST('/')
  @Headers({
    'accessToken' : 'true',
  })
  Future<OrderModel> postOrder({
    @Body() required PostOrderBody body,
  });
}