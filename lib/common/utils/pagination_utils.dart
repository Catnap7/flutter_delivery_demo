import 'package:flutter/widgets.dart';
import 'package:flutter_study_2/common/provider/pagination_provider.dart';

class PaginationUtils {
  static void paginate({
    required ScrollController scrollController,
    required PaginationProvider paginationProvider,
}){
    if (scrollController.offset >
        scrollController.position.maxScrollExtent - 300) {
      // 데이터를 추가 요청한다
      paginationProvider.paginate(
        fetchMore: true,
      );
    }

  }
}