import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/models/visitor.dart';

import '../../auth/repositories/auth_repository.dart';

class AdminRepository {
  final AuthRepository _authRepo;
  AdminRepository(this._authRepo);

  final String baseUrl = '/greenbee_beyond_space/api/admin';

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authRepo.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Map<String, dynamic>>> getUnverifiedUsers() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/users/unverified'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    }
    throw Exception('Failed to load unverified users');
  }

  Future<void> verifyUser(int userId) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/users/$userId/verify'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to verify user');
    }
  }

  Future<List<Visitor>> getAllVisitors() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/visitors'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Visitor.fromJson(json)).toList();
    }
    throw Exception('Failed to load visitors');
  }

  Future<void> updateVisitorStatus(int visitorId, String status) async {
    final headers = await _getHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl/visitors/$visitorId'),
      headers: headers,
      body: json.encode({'status': status}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update visitor status');
    }
  }
}
