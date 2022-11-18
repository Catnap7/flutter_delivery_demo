import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_study_2/common/const/data.dart';
import 'package:flutter_study_2/user/model/user_model.dart';
import 'package:flutter_study_2/user/repository/user_me_repository.dart';

class UserMeStateNotifier extends StateNotifier<UserModelBase?>{
  final UserMeRepository userMeRepository;
  final FlutterSecureStorage secureStorage;


  UserMeStateNotifier({
    required this.userMeRepository,
    required this.secureStorage,
}) : super(UserModelLoading()){
    getMe();
  }

  Future<void> getMe() async {
    final refreshToken = await secureStorage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await secureStorage.read(key: ACCESS_TOKEN_KEY);

    if(refreshToken == null || accessToken == null){
      state = null;
      return;
    }

    final resp = await userMeRepository.getMe();

    state = resp;

  }
}