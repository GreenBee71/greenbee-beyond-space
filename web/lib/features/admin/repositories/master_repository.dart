import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../auth/repositories/auth_repository.dart';

class MasterRepository {
  final AuthRepository _authRepo;
  final String baseUrl = '/greenbee_beyond_space/api/master';

  MasterRepository(this._authRepo);

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authRepo.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> getGlobalStats() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/stats/overview'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load global stats');
  }

  Future<String> uploadBulkBillings(String csvContent, String filename) async {
    final token = await _authRepo.getToken();
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/billings/upload'));
    request.headers['Authorization'] = 'Bearer $token';
    
    request.files.add(http.MultipartFile.fromString(
      'file',
      csvContent,
      filename: filename,
    ));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['message'] as String;
    }
    throw Exception('Failed to upload billings: ${response.body}');
  }

  Future<List<Map<String, dynamic>>> getComplexes() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/complexes'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to load complexes');
  }

  Future<void> createComplex(String name) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/complexes'),
      headers: headers,
      body: json.encode({'name': name}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create complex: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to load global users');
  }

  Future<List<Map<String, dynamic>>> getAnnouncements() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/announcements'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to load announcements');
  }

  Future<void> createAnnouncement(String title, String content, String target) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/announcements'),
      headers: headers,
      body: json.encode({
        'title': title,
        'content': content,
        'target_complex': target,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create announcement: ${response.body}');
    }
  }

  Future<void> deleteComplex(String name) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/complexes/$name'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete complex: ${response.body}');
    }
  }

  Future<void> updateUserRole(int userId, String role) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId/role'),
      headers: headers,
      body: json.encode({'global_role': role}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user role: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getIoTStats() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/stats/iot'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load IoT stats');
  }

  Future<Map<String, dynamic>> getTrends() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/stats/trends'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load trend stats');
  }
}
