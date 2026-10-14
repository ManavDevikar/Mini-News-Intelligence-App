import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../data/datasources/auth_local_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final box = Hive.box('authBox');

  return AuthLocalDataSource(box);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final localDataSource = ref.watch(
    authLocalDataSourceProvider,
  );

  return AuthRepositoryImpl(localDataSource);
});

final authControllerProvider =
    AsyncNotifierProvider<AuthController, bool>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<bool> {
  late final AuthRepository _repository;

  @override
  Future<bool> build() async {
    _repository = ref.read(authRepositoryProvider);

    return _repository.isLoggedIn();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repository.login(
        email: email,
        password: password,
      );

      return true;
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repository.logout();

      return false;
    });
  }
}