import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_api_service.dart';
import '../models/article_model.dart';

class NewsRepositoryImpl
    implements NewsRepository {
  NewsRepositoryImpl(this._apiService);

  final NewsApiService _apiService;

  @override
  Future<List<Article>> getTopHeadlines({
    required String category,
    required int page,
  }) async {
    final response =
        await _apiService.getTopHeadlines(
      category: category,
      page: page,
    );

    final articles =
        response['articles'] as List<dynamic>? ??
            [];

    return articles
        .map(
          (article) =>
              ArticleModel.fromJson(
            Map<String, dynamic>.from(
              article as Map,
            ),
          ),
        )
        .toList();
  }

  @override
  Future<List<Article>> searchArticles({
    required String query,
    required int page,
  }) async {
    final response =
        await _apiService.searchArticles(
      query: query,
      page: page,
    );

    final articles =
        response['articles'] as List<dynamic>? ??
            [];

    return articles
        .map(
          (article) =>
              ArticleModel.fromJson(
            Map<String, dynamic>.from(
              article as Map,
            ),
          ),
        )
        .toList();
  }
}