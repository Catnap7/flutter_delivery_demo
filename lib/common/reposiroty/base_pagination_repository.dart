import 'package:flutter_study_2/common/model/cursor_pagination_model.dart';
import 'package:flutter_study_2/common/model/model_with_id.dart';
import 'package:flutter_study_2/restaurant/model/restaurant_model.dart';
import 'package:flutter_study_2/common/model/pagination_params.dart';

// 인터페이스라는 의미로 I를 붙여준다.
// Pagination은 일반화 해놓고 제네릭으로 받는 타입만 다르게 해서 쓸거기 떄문에
// <T>로 타입은 외부에서 받을거임 ex.RatingModel
abstract class IBasePaginationRepository<T extends IModelWithId> {
  Future<CursorPagination<T>> paginate({
     PaginationParams? paginationParams = const PaginationParams(),
  });
}