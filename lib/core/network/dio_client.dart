import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../constants/api_constants.dart';

class DioClient {
  DioClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout:
                const Duration(seconds: 10),
            receiveTimeout:
                const Duration(seconds: 10),
            sendTimeout:
                const Duration(seconds: 10),
            headers: {
              'Accept': 'application/json',
            },
          ),
        );

  final Dio dio;

  String get apiKey {
    final key =
        dotenv.env[ApiConstants.apiKey];

    if (key == null || key.isEmpty) {
      throw Exception(
        'GNews API key is missing.',
      );
    }

    return key;
  }
}