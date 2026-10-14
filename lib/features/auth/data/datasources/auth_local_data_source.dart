import 'package:hive_flutter/hive_flutter.dart';

class AuthLocalDataSource {
  AuthLocalDataSource();

  final Box _box = Hive.box('authBox');

  Future<void> saveLoginState(
    bool isLoggedIn,
  ) async {
    await _box.put(
      'isLoggedIn',
      isLoggedIn,
    );
  }

  bool getLoginState() {
    return _box.get(
          'isLoggedIn',
          defaultValue: false,
        )
        as bool;
  }

  Future<void> clearLoginState() async {
    await _box.delete('isLoggedIn');
  }
}