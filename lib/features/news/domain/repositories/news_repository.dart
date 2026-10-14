import '../entities/article.dart';

abstract class NewsRepository {
  Future<List<Article>> getTopHeadlines({
    required String category,
    required int page,
  });

  Future<List<Article>> searchArticles({
    required String query,
    required int page,
  });
}