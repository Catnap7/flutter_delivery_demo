import 'package:flutter/material.dart';
import 'package:flutter_study_2/order/model/order_model.dart';

class OrderCard extends StatelessWidget {
  final DateTime orderDate;
  final Image image;
  final String name;
  final String productDetail;
  final int price;

  const OrderCard(
      {required this.orderDate,
      required this.image,
      required this.name,
      required this.productDetail,
      required this.price,
      Key? key})
      : super(key: key);

  factory OrderCard.fromModel({
    required OrderModel model,
  }) {
    final productsDetail = model.products.length < 2 ?
        model.products.first.product.name : '${model.products.first.product.name} 외 ${model.products.length - 1}개';

    return OrderCard(
      orderDate: model.createdAt,
      image: Image.network(model.restaurant.thumbUrl, fit: BoxFit.cover,
      width: 50,
      height: 50,),
      name: model.restaurant.name,
      productDetail: productsDetail,
      price: model.totalPrice,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 2022.09.01
        // padLeft 길이 두자릿수의 빈 공간을 0으로 채움
        Text(
            '${orderDate.year}년 ${orderDate.month.toString().padLeft(2, '0')}월 ${orderDate.day.toString().padLeft(2, '0')}일 주문완료'),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: image,
            ),
            const SizedBox(
              width: 16.0,
            ),
            Column(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Text(productDetail),
                Text('${price}원'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
