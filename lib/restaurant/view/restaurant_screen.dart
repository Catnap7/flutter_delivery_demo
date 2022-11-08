import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/common/const/data.dart';
import 'package:flutter_study_2/common/dio/dio.dart';
import 'package:flutter_study_2/common/model/cursor_pagination_model.dart';
import 'package:flutter_study_2/restaurant/component/restaurant_card.dart';
import 'package:flutter_study_2/restaurant/model/restaurant_model.dart';
import 'package:flutter_study_2/restaurant/provider/restaurant_provider.dart';
import 'package:flutter_study_2/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_study_2/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // 현재 위치가 최대 길이보다 조금 덜되는 위치까지 왔다면
    // 새로운 데이터를 추가 요청한다
    if (_scrollController.offset >
        _scrollController.position.maxScrollExtent - 300) {
      // 데이터를 추가 요청한다
      ref.read(restaurantProvider.notifier).paginate(
            fetchMore: true,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    // 완전 처음 로딩일때
    if (data is CursorPaginationLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 에러
    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetcing

    final cp = data as CursorPagination;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          controller: _scrollController,
          // 빙글빙글 추가하기 위해서 + 1 해준다
          itemCount: cp.data.length + 1,
          itemBuilder: (_, index) {
            if (index == cp.data.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Center(
                  child: data is CursorPaginationFetchingMore
                      ? CircularProgressIndicator()
                      : Text("마지막 데이터입니다"),
                ),
              );
            }

            final pItem = cp.data[index];

            // final pItem = RestaurantModel.fromJson(item);

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RestaurantDetailScreen(
                      id: pItem.id,
                    ),
                  ),
                );
              },
              child: RestaurantCard.fromModel(
                model: pItem,
              ),
            );
          },
          // 각각의 아이템 사이사이에 들어가는 그림 그릴때 사용
          separatorBuilder: (_, index) {
            return const SizedBox(
              height: 16.0,
            );
          },
        ),
      ),
    );
  }
}
