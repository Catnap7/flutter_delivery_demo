import 'package:flutter/material.dart';
import 'package:flutter_study_2/common/component/pagination_list_view.dart';
import 'package:flutter_study_2/restaurant/component/restaurant_card.dart';
import 'package:flutter_study_2/restaurant/model/restaurant_model.dart';
import 'package:flutter_study_2/restaurant/provider/restaurant_provider.dart';
import 'package:flutter_study_2/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginationListView<RestaurantModel>(
        provider: restaurantProvider,
        itemBuilder: (
          _,
          index,
          model,
        ) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RestaurantDetailScreen(
                    id: model.id,
                  ),
                ),
              );
            },
            child: RestaurantCard.fromModel(
              model: model,
            ),
          );
        });
  }
}
