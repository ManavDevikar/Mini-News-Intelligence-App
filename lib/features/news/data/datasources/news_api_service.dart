import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';

class NewsApiService {
  NewsApiService(this._dioClient);

  final DioClient _dioClient;

  Future<Map<String, dynamic>>
      getTopHeadlines({
    required String category,
    required int page,
  }) async {
    try {
      final response =
          await _dioClient.dio.get(
        ApiConstants.topHeadlines,
        queryParameters: {
          'category': category,
          'lang':
              ApiConstants.defaultLanguage,
          'country':
              ApiConstants.defaultCountry,
          'max':
              ApiConstants.pageSize,
          'page': page,
          'apikey':
              _dioClient.apiKey,
        },
      );

      return Map<String, dynamic>.from(
        response.data as Map,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Map<String, dynamic>>
      searchArticles({
    required String query,
    required int page,
  }) async {
    try {
      final response =
          await _dioClient.dio.get(
        ApiConstants.search,
        queryParameters: {
          'q': query,
          'lang':
              ApiConstants.defaultLanguage,
          'country':
              ApiConstants.defaultCountry,
          'max':
              ApiConstants.pageSize,
          'page': page,
          'apikey':
              _dioClient.apiKey,
        },
      );

      return Map<String, dynamic>.from(
        response.data as Map,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(
    DioException exception,
  ) {
    final statusCode =
        exception.response?.statusCode;

    switch (statusCode) {
      case 400:
        return Exception(
          'Invalid news request.',
        );

      case 401:
        return Exception(
          'Invalid GNews API key.',
        );

      case 403:
        return Exception(
          'Daily API quota exceeded.',
        );

      case 429:
        return Exception(
          'Too many requests. Please try again later.',
        );

      case 500:
      case 503:
        return Exception(
          'News service is temporarily unavailable.',
        );

      default:
        if (exception.type ==
            DioExceptionType.connectionError) {
          return Exception(
            'No internet connection.',
          );
        }

        if (exception.type ==
            DioExceptionType.connectionTimeout) {
          return Exception(
            'Connection timed out.',
          );
        }

        if (exception.type ==
            DioExceptionType.receiveTimeout) {
          return Exception(
            'Server response timed out.',
          );
        }

        return Exception(
          'Something went wrong while loading news.',
        );
    }
  }
}