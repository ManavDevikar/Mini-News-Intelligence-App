import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl
    implements AuthRepository {
  AuthRepositoryImpl(
    this._localDataSource,
  );

  final AuthLocalDataSource
      _localDataSource;

  @override
  Future<void> login() async {
    await _localDataSource
        .saveLoginState(true);
  }

  @override
  Future<void> logout() async {
    await _localDataSource
        .clearLoginState();
  }

  @override
  bool isLoggedIn() {
    return _localDataSource
        .getLoginState();
  }
}