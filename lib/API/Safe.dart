import 'dart:convert';
import 'package:http/http.dart' as http;

class APISafe {
  static const String _baseUrl = 'http://localhost:8000/safe';

  static Future<http.Response> getSafe() async {
    final url = Uri.parse(_baseUrl);
    return await http.get(url);
  }

  static Future<http.Response> transfer(Map<String, dynamic> data) async {
    final url = Uri.parse(_baseUrl);
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }
}
