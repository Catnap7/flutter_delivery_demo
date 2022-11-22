import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_study_2/common/const/data.dart';
import 'package:flutter_study_2/common/secure_storage/secure_storage.dart';
import 'package:flutter_study_2/user/model/user_model.dart';
import 'package:flutter_study_2/user/repository/auth_repository.dart';
import 'package:flutter_study_2/user/repository/user_me_repository.dart';
import 'package:logger/logger.dart';


final userMeProvider = StateNotifierProvider<UserMeStateNotifier, UserModelBase?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userMeRepository = ref.watch(userMeRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return UserMeStateNotifier(
    authRepository: authRepository,
    userMeRepository: userMeRepository,
    secureStorage: storage,);
});

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserMeRepository userMeRepository;
  final FlutterSecureStorage secureStorage;

  UserMeStateNotifier({
    required this.authRepository,
    required this.userMeRepository,
    required this.secureStorage,
  }) : super( UserModelLoading()) {
    getMe();
  }

  Future<void> getMe() async {
    final refreshToken = await secureStorage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await secureStorage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      return;
    }

    final resp = await userMeRepository.getMe();

    state = resp;
  }

  Future<UserModelBase> login({
    required String username,
    required String password,
  }) async {
    try {
      state = UserModelLoading();

      final resp = await authRepository.login(
        username: username,
        password: password,
      );

      await secureStorage.write(
        key: REFRESH_TOKEN_KEY,
        value: resp.refreshToken,
      );

      await secureStorage.write(
        key: ACCESS_TOKEN_KEY,
        value: resp.accessToken,
      );

      final userResp = await userMeRepository.getMe();

      state = userResp;

      return userResp;
    } catch (e) {
      state = UserModelError(message: '로그인에 실패했습니다');

      return Future.value(state);
    }
  }

  Future<void> logOut() async {
    state = null;

    // 두개의 토큰을 동시에 삭제하고 둘 다 작업이 끝나면 다음 작업을 진행
    await Future.wait([
      secureStorage.delete(key: REFRESH_TOKEN_KEY),
      secureStorage.delete(key: ACCESS_TOKEN_KEY),
    ]);
  }
}
