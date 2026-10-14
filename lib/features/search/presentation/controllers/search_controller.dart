import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../news/domain/entities/article.dart';
import '../../../news/presentation/controllers/news_controller.dart';

final searchControllerProvider =
    NotifierProvider<
        SearchController,
        AsyncValue<List<Article>>>(
  SearchController.new,
);

class SearchController
    extends Notifier<
        AsyncValue<List<Article>>> {
  Timer? _debounce;

  @override
  AsyncValue<List<Article>> build() {
    ref.onDispose(() {
      _debounce?.cancel();
    });

    return const AsyncData([]);
  }

  void search(String query) {
    _debounce?.cancel();

    final trimmedQuery =
        query.trim();

    if (trimmedQuery.isEmpty) {
      state =
          const AsyncData([]);

      return;
    }

    _debounce = Timer(
      const Duration(
        milliseconds: 500,
      ),
      () {
        _performSearch(
          trimmedQuery,
        );
      },
    );
  }

  Future<void> _performSearch(
    String query,
  ) async {
    state =
        const AsyncLoading();

    try {
      final repository =
          ref.read(
        newsRepositoryProvider,
      );

      final articles =
          await repository.searchArticles(
        query: query,
        page: 1,
      );

      state =
          AsyncData(articles);
    } catch (error, stackTrace) {
      state = AsyncError(
        error,
        stackTrace,
      );
    }
  }

  void clear() {
    _debounce?.cancel();

    state =
        const AsyncData([]);
  }
}