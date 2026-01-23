import 'dart:convert';
import 'package:http/http.dart';

String apiUrl = 'http://localhost:3000/api/employee';

class APIEmployee {
  static Future add(data) async {
    try {
      Map<String, String> ConfigHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/');
      Response response =
          await post(url, headers: ConfigHeaders, body: jsonEncode(data));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future getAll() async {
    try {
      Map<String, String> configHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/');
      Response response = await get(url, headers: configHeaders);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future update(data) async {
    try {
      Map<String, String> configHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/update');
      Response response =
          await post(url, headers: configHeaders, body: jsonEncode(data));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future delete(data) async {
    try {
      Map<String, String> configHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/delete');
      Response response =
          await post(url, headers: configHeaders, body: jsonEncode(data));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future addTrans(data) async {
    try {
      Map<String, String> configHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/emp_tran');
      Response response =
          await post(url, headers: configHeaders, body: jsonEncode(data));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future getTrans(data) async {
    try {
      Map<String, String> configHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/get_emp_trans');
      Response response =
          await post(url, headers: configHeaders, body: jsonEncode(data));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future getTransByDate(data) async {
    try {
      Map<String, String> configHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/get_emp_trans/date');
      Response response =
          await post(url, headers: configHeaders, body: jsonEncode(data));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future deleteTrans(data) async {
    try {
      Map<String, String> configHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/delete_emp_tran');
      Response response =
          await post(url, headers: configHeaders, body: jsonEncode(data));

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
