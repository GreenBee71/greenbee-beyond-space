import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

final dioProvider = Provider<Dio>((ref) {
  // Web production environment (Nginx Proxy) should use relative path
  String baseUrl = 'http://localhost:8000/greenbee_beyond_space/api';
  
  if (kIsWeb) {
    // Browser will handle host/port automatically
    baseUrl = '/greenbee_beyond_space/api';
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
