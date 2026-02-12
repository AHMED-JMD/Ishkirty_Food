import 'dart:convert';
import 'package:http/http.dart';
import 'api_helpers.dart';

String ApiUrl = 'http://localhost:3000/api/business-location';

class APIBusinessLocation {
  static Future getAll() async {
    try {
      final url = Uri.parse('$ApiUrl/');
      Response response = await get(url, headers: buildHeaders());
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future addLocation(data) async {
    try {
      final url = Uri.parse('$ApiUrl/');
      Response response = await post(
        url,
        headers: buildHeaders(),
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future dailyLocation(data) async {
    try {
      final url = Uri.parse('$ApiUrl/daily');
      Response response = await post(
        url,
        headers: buildHeaders(),
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future deleteLocation(data) async {
    try {
      final url = Uri.parse('$ApiUrl/delete');
      Response response = await post(
        url,
        headers: buildHeaders(),
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
