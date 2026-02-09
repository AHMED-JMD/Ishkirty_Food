import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_helpers.dart';

class APISafeDaily {
  static const String baseUrl = 'http://localhost:3000/api/safe-dailies';

  static Future<http.Response> add(Map<String, dynamic> body) async {
    return await http.post(
      Uri.parse('$baseUrl/add'),
      headers: buildHeaders(),
      body: jsonEncode(attachBusinessLocation(body)),
    );
  }

  static Future<http.Response> getByDate(data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/by-date'),
      headers: buildHeaders(),
      body: jsonEncode(attachBusinessLocation(data)),
    );

    return response;
  }

  static Future<http.Response> delete(data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delete'),
      headers: buildHeaders(),
      body: jsonEncode(attachBusinessLocation(data)),
    );
    return response;
  }
}
