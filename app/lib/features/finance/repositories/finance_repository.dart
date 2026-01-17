import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/models/admin_fee.dart';
import '../../../core/models/energy_usage.dart';
import '../../../core/models/energy_coach.dart';

class FinanceRepository {
  static const String baseUrl = "/greenbee_beyond_space/api/finance";

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<AdminFee> getLatestFee() async {
    final response = await http.get(
      Uri.parse('$baseUrl/fees/latest'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return AdminFee.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load admin fee: ${response.statusCode}');
    }
  }

  Future<List<EnergyUsage>> getEnergyHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/energy/monthly'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => EnergyUsage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load energy history: ${response.statusCode}');
    }
  }

  Future<EnergyCoachResponse> getEnergyCoachTips() async {
    final response = await http.get(
      Uri.parse('$baseUrl/energy/coach'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return EnergyCoachResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load energy coach tips: ${response.statusCode}');
    }
  }
}
