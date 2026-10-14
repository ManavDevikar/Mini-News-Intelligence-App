import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.id,
    required super.title,
    required super.description,
    required super.content,
    required super.url,
    required super.imageUrl,
    required super.publishedAt,
    required super.sourceName,
    required super.sourceUrl,
    required super.sourceCountry,
  });

  factory ArticleModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final source =
        json['source'] as Map<String, dynamic>? ??
            {};

    return ArticleModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description:
          json['description']?.toString() ?? '',
      content:
          json['content']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      imageUrl:
          json['image']?.toString() ?? '',
      publishedAt:
          DateTime.tryParse(
                json['publishedAt']
                        ?.toString() ??
                    '',
              ) ??
              DateTime.now(),
      sourceName:
          source['name']?.toString() ?? '',
      sourceUrl:
          source['url']?.toString() ?? '',
      sourceCountry:
          source['country']?.toString() ?? '',
    );
  }
}