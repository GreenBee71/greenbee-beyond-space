import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

final dioProvider = Provider<Dio>((ref) {
  // Web production environment should use relative path /api
  String baseUrl = '/api';
  
  if (!kIsWeb) {
    // For mobile/local testing outside browser
    baseUrl = 'http://localhost:8080/api';
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  
  return dio;
});
