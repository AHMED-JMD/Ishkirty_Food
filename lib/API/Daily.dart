import 'dart:convert';
import 'package:http/http.dart';

String ApiUrl = 'http://localhost:3000/api/daily';

class APIDaily {
  static Future getAll() async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      final url = Uri.parse('$ApiUrl/');
      Response response = await get(url, headers: headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future getOne(data) async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      final url = Uri.parse('$ApiUrl/get-one');
      Response response =
          await post(url, headers: headers, body: jsonEncode(data));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future getByDate(data) async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      final url = Uri.parse('$ApiUrl/date');
      Response response =
          await post(url, headers: headers, body: jsonEncode(data));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future addDaily(data) async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      final url = Uri.parse('$ApiUrl/');
      Response response =
          await post(url, headers: headers, body: jsonEncode(data));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future deleteDaily(data) async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      final url = Uri.parse('$ApiUrl/delete');
      Response response =
          await post(url, headers: headers, body: jsonEncode(data));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future unlockDaily(data) async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      final url = Uri.parse('$ApiUrl/unlock');
      Response response =
          await post(url, headers: headers, body: jsonEncode(data));
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
