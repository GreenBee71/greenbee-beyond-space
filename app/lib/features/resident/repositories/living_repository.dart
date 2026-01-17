import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/models/visitor.dart';
import '../../../core/models/vote.dart';
import '../../../core/models/search_result.dart';

class LivingRepository {
  static const String baseUrl = "/greenbee_beyond_space/api/living";

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<Visitor>> getVisitors() async {
    final response = await http.get(
      Uri.parse('$baseUrl/visitors'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Visitor.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load visitors: ${response.statusCode}');
    }
  }

  Future<Visitor> createVisitor(String carNumber, String visitorName, String visitDate, String purpose) async {
    final response = await http.post(
      Uri.parse('$baseUrl/visitors'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'car_number': carNumber,
        'visitor_name': visitorName,
        'visit_date': visitDate,
        'purpose': purpose,
      }),
    );
    if (response.statusCode == 200) {
      return Visitor.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create visitor: ${response.statusCode}');
    }
  }

  Future<List<Vote>> getVotes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/votes'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Vote.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load votes: ${response.statusCode}');
    }
  }

  Future<List<SearchResult>> searchCommunity(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search?query=${Uri.encodeComponent(query)}'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => SearchResult.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search community: ${response.statusCode}');
    }
  }
}
