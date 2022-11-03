import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

// Provider에서 사용할거기때문에 삭제해버림
// final storage = FlutterSecureStorage();

// 192.168.25.3
final emulatorIp = '192.168.25.2:3000';
// mac으로 가상 핸드폰을 테스트 할 때는 시뮬레이터
final simulatorIp = '127.0.0.1:3000';

// dio 패키지에서 불러 옴
final ip = Platform.isAndroid ? emulatorIp : simulatorIp;