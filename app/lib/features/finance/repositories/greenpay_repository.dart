import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/models/green_pay.dart';

class GreenPayRepository {
  static const String baseUrl = "/greenbee_beyond_space/api/greenpay";

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Wallet> getWallet() async {
    final response = await http.get(
      Uri.parse('$baseUrl/wallet'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return Wallet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load wallet');
    }
  }

  Future<List<Transaction>> getTransactions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/transactions'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((j) => Transaction.fromJson(j)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  Future<void> charge(double amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/charge'),
      headers: await _getHeaders(),
      body: jsonEncode({'amount': amount}),
    );

    if (response.statusCode != 200) {
      throw Exception('Charge failed');
    }
  }

  Future<void> pay(double amount, String description, {int? feeId}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pay${feeId != null ? "?fee_id=$feeId" : ""}'),
      headers: await _getHeaders(),
      body: jsonEncode({'amount': amount, 'description': description}),
    );

    if (response.statusCode != 200) {
      throw Exception('Payment failed');
    }
  }
}
