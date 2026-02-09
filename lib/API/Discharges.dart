import 'dart:convert';
import 'package:http/http.dart';
import 'api_helpers.dart';

String dischargesApiUrl = 'http://localhost:3000/api/discharges';

class APIDischarges {
  static Future getAll() async {
    try {
      final url = Uri.parse('$dischargesApiUrl/');
      Response response = await get(url, headers: buildHeaders());
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future getByDate(data) async {
    try {
      final url = Uri.parse('$dischargesApiUrl/date');
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

  static Future addDischarge(data) async {
    try {
      final url = Uri.parse('$dischargesApiUrl/');
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

  static Future deleteDischarge(data) async {
    try {
      final url = Uri.parse('$dischargesApiUrl/delete');
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
