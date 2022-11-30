import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/common/const/colors.dart';
import 'package:flutter_study_2/common/layout/default_layout.dart';
import 'package:flutter_study_2/order/provider/order_provider.dart';
import 'package:flutter_study_2/order/view/order_done_screen.dart';
import 'package:flutter_study_2/product/component/product_card.dart';
import 'package:flutter_study_2/user/provider/basket_provider.dart';
import 'package:go_router/go_router.dart';

class BasketScreen extends ConsumerWidget {
  static String get routeName => 'basket';

  const BasketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    if (basket.isEmpty) {
      return DefaultLayout(
        title: '장바구니',
        child: Center(
          child: Text('Basket is empty'),
        ),
      );
    }

    final productsTotal = basket.fold<int>(
      0,
      (p, n) => p + (n.product.price * n.count),
    );

    final deleveryFee = basket.first.product.restaurant.deliveryFee;

    return DefaultLayout(
      title: '장바구니',
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, __) => const Divider(
                    height: 32.0,
                  ),
                  itemBuilder: (context, index) {
                    final model = basket[index];
                    return ProductCard.fromProductModel(
                      model: model.product,
                      onAdd: () {
                        ref.read(basketProvider.notifier).addToBasket(
                              product: model.product,
                            );
                      },
                      onSubtract: () {
                        ref.read(basketProvider.notifier).removeFromBasket(
                              product: model.product,
                            );
                      },
                    );
                  },
                  itemCount: basket.length,
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '장바구니 금액',
                        style: TextStyle(
                          color: BODY_TEXT_COLOR,
                        ),
                      ),
                      Text(
                        '₩ ' + productsTotal.toString(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '배달비',
                        style: TextStyle(
                          color: BODY_TEXT_COLOR,
                        ),
                      ),
                      if (basket.isNotEmpty)
                        Text('₩ ' + deleveryFee.toString()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '총액',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text((deleveryFee + productsTotal).toString()),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final resp = await ref.read(orderProvider.notifier).postOrder();

                        if(resp){
                          context.goNamed(OrderDoneScreen.routeName);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('결제 실패했습니다.'),
                            ),
                          );

                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                      ),
                      child: const Text(
                        '결제하기',
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
