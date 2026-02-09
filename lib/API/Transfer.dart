import 'dart:convert';
import 'package:http/http.dart';
import 'api_helpers.dart';

String apiUrl = 'http://localhost:3000/api/transfer';

class API_Transfer {
  static Future add(data) async {
    try {
      final url = Uri.parse('$apiUrl/');
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

  //get data
  static Future Get(data) async {
    try {
      final url = Uri.parse('$apiUrl/get');
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

  //modify data
  static Future Modify(data) async {
    try {
      final url = Uri.parse('$apiUrl/update');
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

  //modify data
  //delete data
  static Future Delete(data) async {
    try {
      final url = Uri.parse('$apiUrl/delete');
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
