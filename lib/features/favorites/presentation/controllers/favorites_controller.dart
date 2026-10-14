import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../news/domain/entities/article.dart';
import '../../data/datasources/favorites_local_data_source.dart';

final favoritesLocalDataSourceProvider =
    Provider<FavoritesLocalDataSource>(
  (ref) {
    return FavoritesLocalDataSource();
  },
);

final favoritesControllerProvider =
    NotifierProvider<
        FavoritesController,
        List<Article>>(
  FavoritesController.new,
);

class FavoritesController
    extends Notifier<List<Article>> {
  late FavoritesLocalDataSource
      _localDataSource;

  @override
  List<Article> build() {
    _localDataSource =
        ref.read(
          favoritesLocalDataSourceProvider,
        );

    return _localDataSource
        .getFavorites();
  }

  bool isFavorite(
    String articleId,
  ) {
    return _localDataSource
        .isFavorite(articleId);
  }

  Future<void> toggleFavorite(
    Article article,
  ) async {
    final isSaved =
        _localDataSource
            .isFavorite(
      article.id,
    );

    if (isSaved) {
      await _localDataSource
          .removeFavorite(
        article.id,
      );
    } else {
      await _localDataSource
          .saveFavorite(
        article,
      );
    }

    state = _localDataSource
        .getFavorites();
  }
}