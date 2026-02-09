import 'dart:convert';
import 'package:http/http.dart';
import 'api_helpers.dart';

String apiUrl = 'http://localhost:3000/api/employee';

class APIEmployee {
  static Future add(data) async {
    try {
      final url = Uri.parse('$apiUrl/');
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

  static Future getAll() async {
    try {
      final url = Uri.parse('$apiUrl/');
      Response response = await get(url, headers: buildHeaders());

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future update(data) async {
    try {
      final url = Uri.parse('$apiUrl/update');
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

  static Future delete(data) async {
    try {
      final url = Uri.parse('$apiUrl/delete');
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

  static Future addTrans(data) async {
    try {
      final url = Uri.parse('$apiUrl/emp_tran');
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

  static Future getTrans(data) async {
    try {
      final url = Uri.parse('$apiUrl/get_emp_trans');
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

  static Future getTransByDate(data) async {
    try {
      final url = Uri.parse('$apiUrl/get_emp_trans/date');
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

  static Future deleteTrans(data) async {
    try {
      final url = Uri.parse('$apiUrl/delete_emp_tran');
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

  static Future runNewMonth(data) async {
    try {
      final url = Uri.parse('$apiUrl/new_month');
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
