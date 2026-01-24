import 'dart:convert';
import 'package:http/http.dart' as http;

const String _baseUrl = 'http://localhost:3000/api/safe/';

class APISafe {
  static Future<http.Response> dailySafe(Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/dailySafe');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response;
  }

  static Future<http.Response> getSafe() async {
    final url = Uri.parse(_baseUrl);
    final response = await http.get(url);
    return response;
  }

  static Future<http.Response> transfer(Map<String, dynamic> data) async {
    final url = Uri.parse("$_baseUrl/transfer");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response;
  }
}
