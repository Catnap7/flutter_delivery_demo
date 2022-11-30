import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/common/const/colors.dart';
import 'package:flutter_study_2/common/layout/default_layout.dart';
import 'package:flutter_study_2/common/model/cursor_pagination_model.dart';
import 'package:flutter_study_2/common/utils/pagination_utils.dart';
import 'package:flutter_study_2/product/component/product_card.dart';
import 'package:flutter_study_2/product/model/product_model.dart';
import 'package:flutter_study_2/rating/component/raiting_card.dart';
import 'package:flutter_study_2/rating/model/rating_model.dart';
import 'package:flutter_study_2/restaurant/component/restaurant_card.dart';
import 'package:flutter_study_2/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_study_2/restaurant/model/restaurant_model.dart';
import 'package:flutter_study_2/restaurant/provider/restaurant_provider.dart';
import 'package:flutter_study_2/restaurant/provider/restaurant_rating_provider.dart';
import 'package:flutter_study_2/restaurant/view/basket_screen.dart';
import 'package:flutter_study_2/user/provider/basket_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'restaurantDetail';
  final String id;

  const RestaurantDetailScreen({required this.id, Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);

    _scrollController.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
      scrollController: _scrollController,
      paginationProvider: ref.read(
        restaurantRatingProvider(widget.id).notifier,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));
    final basket = ref.watch(basketProvider);

    if (state == null) {
      return const DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultLayout(
      title: state.name,
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          // pushNamed는 일반적인 화면이동. 현재 라우트 위에 스크린을 올리는 방식 (뒤로가기 있음)
          // goNamed는 현재 라우트를 교체하는 방식 (뒤로가기 없음)
          // BasketScreen 라우트 위에 상위 라우트가 없기 때문
          context.pushNamed(BasketScreen.routeName);

        },
        child: Badge(
          showBadge: basket.isNotEmpty,
          badgeContent: Text(
            basket
                .fold<int>(
                    0, (previousValue, next) => previousValue + next.count)
                .toString(),
            style: const TextStyle(
              color: PRIMARY_COLOR,
              fontSize: 10.0,
            ),
          ),
          child: const Icon(Icons.shopping_bag_outlined),
          badgeColor: Colors.white,
        ),
      ),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          renderTop(model: state),
          if (state is! RestaurantDetailModel) renderLoading(),
          if (state is RestaurantDetailModel) renderLabel(),
          if (state is RestaurantDetailModel)
            renderProduct(products: state.products, restaurant: state),
          if (ratingsState is CursorPagination<RatingModel>)
            renderRatings(
              models: ratingsState.data,
            ),
        ],
      ),
    );
  }

  SliverPadding renderRatings({
    required List<RatingModel> models,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: RatingCard.fromModel(
              model: models[index],
            ),
          ),
          childCount: models.length,
        ),
      ),
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(List.generate(
            3,
            (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SkeletonParagraph(
                    style: SkeletonParagraphStyle(
                      lines: 5,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ))),
      ),
    );
  }

  SliverPadding renderLabel() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }

  SliverPadding renderProduct({
    required RestaurantModel restaurant,
    required List<RestaurantProductModel> products,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];
            return InkWell(
              onTap: () {
                ref.read(basketProvider.notifier).addToBasket(
                      product: ProductModel(
                        id: model.id,
                        name: model.name,
                        detail: model.detail,
                        price: model.price,
                        imgUrl: model.imgUrl,
                        restaurant: restaurant,
                      ),
                    );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ProductCard.fromRestaurantProductModel(model: model),
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
}
