import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../news/data/models/article_model.dart';
import '../../../news/domain/entities/article.dart';

class FavoritesLocalDataSource {
  FavoritesLocalDataSource();

  final Box _box =
      Hive.box('favoritesBox');

  Future<void> saveFavorite(
    Article article,
  ) async {
    final data = {
      'id': article.id,
      'title': article.title,
      'description':
          article.description,
      'content': article.content,
      'url': article.url,
      'image':
          article.imageUrl,
      'publishedAt':
          article.publishedAt
              .toIso8601String(),
      'source': {
        'name':
            article.sourceName,
        'url':
            article.sourceUrl,
        'country':
            article.sourceCountry,
      },
    };

    await _box.put(
      article.id,
      jsonEncode(data),
    );
  }

  Future<void> removeFavorite(
    String articleId,
  ) async {
    await _box.delete(articleId);
  }

  bool isFavorite(
    String articleId,
  ) {
    return _box.containsKey(
      articleId,
    );
  }

  List<Article> getFavorites() {
    return _box.values.map((value) {
      final json =
          jsonDecode(value as String);

      return ArticleModel.fromJson(
        Map<String, dynamic>.from(
          json,
        ),
      );
    }).toList();
  }
}