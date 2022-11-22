import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study_2/common/view/error_screen.dart';
import 'package:flutter_study_2/user/provider/auth_provider.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // watch - 값이 변경될떄마다 다시 빌드
  // read - 한번만 읽고 값이 변경돼도 다시 빌드하지 않음
  final provider = ref.read(authProvider);

  return GoRouter(
    // 앱 첫 시작화면 지정
    initialLocation: '/splash',
    errorBuilder: (context, state) =>
        ErrorScreen(error: state.error.toString()),
    routes: provider.routes,
    refreshListenable: provider,
    redirect: provider.redirectLogic,
  );
});
