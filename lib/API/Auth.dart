import 'dart:convert';
import 'package:http/http.dart';
import 'api_helpers.dart';

String apiUrl = 'http://localhost:3000/api/admin';

class APIAuth {
  static Future GetManagers() async {
    try {
      final url = Uri.parse('$apiUrl/');
      Response response = await get(
        url,
        headers: buildHeaders(),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future Login(data) async {
    try {
      final url = Uri.parse('$apiUrl/login');

      Response response = await post(
        url,
        headers: buildHeaders(),
        body: jsonEncode(attachBusinessLocation(data)),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future getByToken(String token) async {
    try {
      final url = Uri.parse('$apiUrl/get-user');
      Response response = await get(
        url,
        headers: buildHeaders(extra: {"Authorization": token}),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future Register(data) async {
    try {
      final url = Uri.parse('$apiUrl/register');
      Response response = await post(
        url,
        headers: buildHeaders(),
        body: jsonEncode(attachBusinessLocation(data)),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future UpdatPassword(data) async {
    try {
      final url = Uri.parse('$apiUrl/update_password');
      Response response = await post(
        url,
        headers: buildHeaders(),
        body: jsonEncode(attachBusinessLocation(data)),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return response.body;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future DeleteManager(data) async {
    try {
      final url = Uri.parse('$apiUrl/delete-user');
      Response response = await post(
        url,
        headers: buildHeaders(),
        body: jsonEncode(attachBusinessLocation(data)),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return response.body;
      }
    } catch (e) {
      rethrow;
    }
  }
}
