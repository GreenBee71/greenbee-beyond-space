import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

final dioProvider = Provider<Dio>((ref) {
  // Production relative path for domain-based routing with root_path
  String baseUrl = '/greenbee_beyond_space/api';
  
  if (!kIsWeb) {
    // For mobile/local testing outside browser
    baseUrl = 'http://localhost:8080/greenbee_beyond_space/api';
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
