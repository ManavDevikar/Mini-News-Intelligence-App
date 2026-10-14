import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._localDataSource);

  final AuthLocalDataSource _localDataSource;

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    // Demo authentication.
    //
    // No backend authentication was specified
    // in the assignment, so we simply persist
    // the login state locally.

    await _localDataSource.saveLoginState();
  }

  @override
  bool isLoggedIn() {
    return _localDataSource.isLoggedIn();
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearLoginState();
  }
}