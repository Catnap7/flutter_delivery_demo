import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/common/const/colors.dart';
import 'package:flutter_study_2/product/model/product_model.dart';
import 'package:flutter_study_2/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_study_2/user/provider/basket_provider.dart';

class ProductCard extends ConsumerWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;
  final String id;
  final VoidCallback? onSubtract;
  final VoidCallback? onAdd;

  const ProductCard(
      {required this.image,
      required this.name,
      required this.detail,
      required this.price,
      required this.id,
      this.onSubtract,
      this.onAdd,
      Key? key})
      : super(key: key);

  factory ProductCard.fromProductModel({
    required ProductModel model,
    VoidCallback? onSubtract,
    VoidCallback? onAdd,
  }) {
    return ProductCard(
      id: model.id,
      image: Image.network(
        model.imgUrl,
        fit: BoxFit.cover,
        width: 110,
        height: 110,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
      onSubtract: onSubtract,
      onAdd: onAdd,
    );
  }

  factory ProductCard.fromRestaurantProductModel({
    required RestaurantProductModel model,
    VoidCallback? onSubtract,
    VoidCallback? onAdd,
  }) {
    return ProductCard(
      id: model.id,
      image: Image.network(
        model.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
      onSubtract: onSubtract,
      onAdd: onAdd,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final basket = ref.watch(basketProvider);

    // 내부에 있는 모든 위젯들이 최대 크기를 차지하는 위젯 만큼 크기를 차지하게 됨
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: image,
              ),
              const SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      detail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: BODY_TEXT_COLOR,
                      ),
                    ),
                    Text(
                      price.toString(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (onSubtract != null && onAdd != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _Footer(
              total: (basket.firstWhere((e) => e.product.id == id).count *
                  basket.firstWhere((e) => e.product.id == id).product.price).toString(),
              count: basket.firstWhere((e) => e.product.id == id).count,
              onSubtract: onSubtract!,
              onAdd: onAdd!,
            ),
          ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final String total;
  final int count;
  final VoidCallback onSubtract;
  final VoidCallback onAdd;

  const _Footer({
    required this.total,
    required this.count,
    required this.onSubtract,
    required this.onAdd,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '총액 ₩ $total',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: PRIMARY_COLOR,
            ),
          ),
        ),
        Row(
          children: [
            renderButton(icon: Icons.remove, onTap: onSubtract),
            const SizedBox(
              width: 8.0,
            ),
            Text(
              count.toString(),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: BODY_TEXT_COLOR,
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            renderButton(icon: Icons.add, onTap: onAdd),
          ],
        ),
      ],
    );
  }

  Widget renderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: PRIMARY_COLOR,
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: PRIMARY_COLOR,
        ),
      ),
    );
  }
}
