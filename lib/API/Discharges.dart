import 'dart:convert';
import 'package:http/http.dart';

String dischargesApiUrl = 'http://localhost:3000/api/discharges';

class APIDischarges {
  static Future getAll() async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      final url = Uri.parse('$dischargesApiUrl/');
      Response response = await get(url, headers: headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future getByDate(data) async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      final url = Uri.parse('$dischargesApiUrl/date');
      Response response =
          await post(url, headers: headers, body: jsonEncode(data));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future addDischarge(data) async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      final url = Uri.parse('$dischargesApiUrl/');
      Response response =
          await post(url, headers: headers, body: jsonEncode(data));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future deleteDischarge(data) async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      final url = Uri.parse('$dischargesApiUrl/delete');
      Response response =
          await post(url, headers: headers, body: jsonEncode(data));
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
