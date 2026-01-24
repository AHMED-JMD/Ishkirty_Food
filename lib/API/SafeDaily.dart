import 'dart:convert';
import 'package:http/http.dart' as http;

class APISafeDaily {
  static const String baseUrl = 'http://localhost:3000/api/safe-dailies';

  static Future<http.Response> add(Map<String, dynamic> body) async {
    return await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> getByDate(data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/by-date'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    return response;
  }

  static Future<http.Response> delete(data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delete'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response;
  }
}
