import 'dart:convert';
import 'package:http/http.dart';
import 'api_helpers.dart';

String ApiUrl = 'http://localhost:3000/api/daily';

class APIDaily {
  static Future getAll() async {
    try {
      final url = Uri.parse('$ApiUrl/');
      Response response = await get(url, headers: buildHeaders());
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future getOne(data) async {
    try {
      final url = Uri.parse('$ApiUrl/get-one');
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

  static Future getByDate(data) async {
    try {
      final url = Uri.parse('$ApiUrl/date');
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

  static Future addDaily(data) async {
    try {
      final url = Uri.parse('$ApiUrl/');
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

  static Future deleteDaily(data) async {
    try {
      final url = Uri.parse('$ApiUrl/delete');
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

  static Future unlockDaily(data) async {
    try {
      final url = Uri.parse('$ApiUrl/unlock');
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

  static Future syncDaily(data) async {
    try {
      final url = Uri.parse('$ApiUrl/sync');
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
}
