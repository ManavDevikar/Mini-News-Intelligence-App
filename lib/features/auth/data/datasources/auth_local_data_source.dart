import 'package:hive/hive.dart';

class AuthLocalDataSource {
  AuthLocalDataSource(this._box);

  final Box _box;

  static const String isLoggedInKey = 'is_logged_in';

  Future<void> saveLoginState() async {
    await _box.put(isLoggedInKey, true);
  }

  bool isLoggedIn() {
    return _box.get(
          isLoggedInKey,
          defaultValue: false,
        ) ==
        true;
  }

  Future<void> clearLoginState() async {
    await _box.delete(isLoggedInKey);
  }
}