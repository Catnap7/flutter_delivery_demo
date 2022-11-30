import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/common/model/cursor_pagination_model.dart';
import 'package:flutter_study_2/common/provider/pagination_provider.dart';
import 'package:flutter_study_2/order/model/order_model.dart';
import 'package:flutter_study_2/order/model/post_order_body.dart';
import 'package:flutter_study_2/order/repository/order_repository.dart';
import 'package:flutter_study_2/user/provider/basket_provider.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(orderRepository);
  return OrderStateNotifier(
    ref: ref,
    repository: repo,
  );
});

class OrderStateNotifier extends PaginationProvider<OrderModel, OrderRepository> {
  final Ref ref;

  OrderStateNotifier({
    required this.ref,
    required super.repository,
  });

  Future<bool> postOrder() async {
    try {
      final uuid = Uuid();

      // id값은 교유해야 하기 때문에 고유한 값을 가지는 난수발생
      final id = uuid.v4();
      final state = ref.read(basketProvider);

      final resp = await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: state
              .map(
                (e) => PostOrderBodyProduct(
                  productId: e.product.id,
                  count: e.count,
                ),
              )
              .toList(),
          totalPrice: state.fold<int>(
              0,
              (previousValue, element) =>
                  previousValue + (element.product.price * element.count)),
          createdAt: DateTime.now().toString(),
        ),
      );
      return true;
    } on Exception catch (e) {
      Logger().e(e);
      return false;
    }
  }
}
