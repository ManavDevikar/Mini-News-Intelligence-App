import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/auth_local_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

final authLocalDataSourceProvider =
    Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource();
});

final authRepositoryProvider =
    Provider<AuthRepository>((ref) {
  final dataSource = ref.read(
    authLocalDataSourceProvider,
  );

  return AuthRepositoryImpl(
    dataSource,
  );
});

final authControllerProvider =
    AsyncNotifierProvider<
        AuthController,
        bool>(
  AuthController.new,
);

class AuthController
    extends AsyncNotifier<bool> {
  late AuthRepository _repository;

  @override
  FutureOr<bool> build() {
    _repository = ref.read(
      authRepositoryProvider,
    );

    // Restore login state from Hive
    return _repository.isLoggedIn();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    // Demo authentication.
    // Email/password validation is handled
    // by LoginScreen.

    state = const AsyncLoading();

    try {
      await _repository.login();
      state = const AsyncData(true);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    try {
      await _repository.logout();
      state = const AsyncData(false);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}