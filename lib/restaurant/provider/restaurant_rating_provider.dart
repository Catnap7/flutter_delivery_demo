import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/common/model/cursor_pagination_model.dart';
import 'package:flutter_study_2/restaurant/repository/restaurant_rating_repository.dart';

class RestaurantRatingStateNotifier
    extends StateNotifier<CursorPaginationBase> {
  final RestaurantRatingRepository restaurantRatingRepository;

  RestaurantRatingStateNotifier({
    required this.restaurantRatingRepository,
  }) : super(
          CursorPaginationLoading(),
        );
}
