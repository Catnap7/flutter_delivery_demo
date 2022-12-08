import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/common/model/cursor_pagination_model.dart';
import 'package:flutter_study_2/common/model/model_with_id.dart';
import 'package:flutter_study_2/common/model/pagination_params.dart';
import 'package:flutter_study_2/common/reposiroty/base_pagination_repository.dart';

class _PaginationInfo {
  final int fetchCount;
  // 추가로 데이터 더 가져오기
  // true - 추가로 데이터 더 가져옴
  // false - 새로고침 (현재 상태를 덮어씌움)
  final bool fetchMore;

  // 강제로 다시 로딩하기
  // true - CursorPaginationLoading()
  final bool forceRefetch;

  _PaginationInfo({
    this.fetchCount = 20,
    this.fetchMore = false,
    this.forceRefetch = false,
  });
}

class PaginationProvider<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;
  final pagitnationThrothle = Throttle(
     Duration(seconds: 5),
    initialValue: _PaginationInfo(),
    // 함수 실행할때 넣어주는 값이 똑같으면 실행하지 않는다. 지금은 false라서 매번 실행할때마다 쓰로틀링이 걸림
    checkEquality: false,
  );

  PaginationProvider({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();

    // pagitnationThrothle에 리스너를 달아놨기 때문에 값이 들어오면 실행됨.
    // 지금의 경우엔 paginate() 함수에 setValue를 해놨기 때문에 setValue가 실행되면 리스너도 실행됨.
    pagitnationThrothle.values.listen((state) {
      _throttledPagination(state);
    });
  }

  Future<void> paginate({
    int fetchCount = 20,
    // 추가로 데이터 더 가져오기
    // true - 추가로 데이터 더 가져옴
    // false - 새로고침 (현재 상태를 덮어씌움)
    bool fetchMore = false,
    // 강제로 다시 로딩하기
    // true - CursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    // setValue만 해둬도 쓰로틀을 통해서 _throttledPagination실행하게함
    pagitnationThrothle.setValue(_PaginationInfo(
      fetchMore: fetchMore,
      forceRefetch: forceRefetch,
      fetchCount: fetchCount,
    ));
  }

  _throttledPagination(_PaginationInfo info) async {
    final fetchCount = info.fetchCount;
    final fetchMore = info.fetchMore;
    final forceRefetch = info.forceRefetch;
    try {
      // 5가지 가능성
      // State의 상태
      // [상태가]
      // 1) CursorPagination - 정상적으로 데이터가 있는 상태
      // 2) CursorPaginationLoading - 데이터가 로딩중인 상태 (현재 캐시 없음)
      // 3) CursorPaginationError - 데이터 로딩중 에러가 발생한 상태
      // 4) CursorPaginationRefetching -첫번째 페이지부터 다시 데이터를 가져올때
      // 5) CursorPaginationFetchingMore - 추가 데이터를 paginate 해오라는 요청을 받았을때

      // 바로 반환하는 상황
      // 1) hasMore = false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고있다면)
      // 2) 로딩중 - fetchMore : true (fetchMore 요청은 리스트 맨 아래에 닿아서 데이터 요청을 하고있는 중
      //    이미 요청중인데 거기에 또 요청을 하면 안됨.
      //    근데 fetchMore가 아닐때 - 새로고침의 의도가 있다.
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;

        if (!pState.meta.hasMore) {
          return;
        }
      }
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      // 2번 반환 상황
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // fetchMore
      // 데이터를 추가로 더 가져오는 상황
      if (fetchMore) {
        final pState = state as CursorPagination<T>;

        state = CursorPaginationFetchingMore<T>(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );

        // 데이터를 처음부터 가져오는 상황
      } else {
        // 만약에 데이터가 있는 상황이라면
        // 기존 데이터를 보존한채로 Fetch (API 요청)를 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;

          state = CursorPaginationRefetching<T>(
            meta: pState.meta,
            data: pState.data,
          );
        }
        // 나머지 상황
        else {
          state = CursorPaginationLoading();
        }
      }
      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;

        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      } else {
        state = resp;
      }
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      state = CursorPaginationError(
        message: '데이터를 가져오는데 실패했습니다',
      );
    }
  }
}
