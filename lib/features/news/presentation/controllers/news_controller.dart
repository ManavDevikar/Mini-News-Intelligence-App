import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/news_api_service.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../../../../core/network/dio_client.dart';

final dioClientProvider =
    Provider<DioClient>((ref) {
  return DioClient();
});

final newsApiServiceProvider =
    Provider<NewsApiService>((ref) {
  final dioClient =
      ref.watch(dioClientProvider);

  return NewsApiService(dioClient);
});

final newsRepositoryProvider =
    Provider<NewsRepository>((ref) {
  final apiService =
      ref.watch(newsApiServiceProvider);

  return NewsRepositoryImpl(apiService);
});

final newsControllerProvider =
    AsyncNotifierProvider<
        NewsController,
        List<Article>>(
  NewsController.new,
);

class NewsController
    extends AsyncNotifier<List<Article>> {
  late NewsRepository _repository;

  String _selectedCategory =
      'business';

  int _currentPage = 1;

  bool _isLoadingMore = false;

  bool _hasMore = true;

  String get selectedCategory =>
      _selectedCategory;

  bool get isLoadingMore =>
      _isLoadingMore;

  bool get hasMore => _hasMore;

  @override
  Future<List<Article>> build() async {
    _repository =
        ref.read(newsRepositoryProvider);

    return _fetchFirstPage(
      _selectedCategory,
    );
  }

  Future<List<Article>> _fetchFirstPage(
    String category,
  ) async {
    _currentPage = 1;
    _hasMore = true;

    final articles =
        await _repository.getTopHeadlines(
      category: category,
      page: 1,
    );

    if (articles.isEmpty) {
      _hasMore = false;
    }

    return articles;
  }

  Future<void> changeCategory(
    String category,
  ) async {
    if (_selectedCategory ==
        category) {
      return;
    }

    _selectedCategory = category;

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => _fetchFirstPage(
        category,
      ),
    );
  }

  Future<void> refreshNews() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => _fetchFirstPage(
        _selectedCategory,
      ),
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore ||
        !_hasMore ||
        state.value == null) {
      return;
    }

    _isLoadingMore = true;

    try {
      final nextPage =
          _currentPage + 1;

      final newArticles =
          await _repository
              .getTopHeadlines(
        category: _selectedCategory,
        page: nextPage,
      );

      if (newArticles.isEmpty) {
        _hasMore = false;
        return;
      }

      _currentPage = nextPage;

      final currentArticles =
          state.value ?? [];

      state = AsyncData([
        ...currentArticles,
        ...newArticles,
      ]);
    } catch (error, stackTrace) {
      state = AsyncError(
        error,
        stackTrace,
      );
    } finally {
      _isLoadingMore = false;
    }
  }
}