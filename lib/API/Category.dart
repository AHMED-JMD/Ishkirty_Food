import 'dart:convert';
import 'package:http/http.dart';
import 'api_helpers.dart';

String apiCategoryUrl = 'http://localhost:3000/api/categories';

class APICategory {
  // get all categories
  static Future Get() async {
    try {
      final url = Uri.parse('$apiCategoryUrl/');
      Response response = await get(url, headers: buildHeaders());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  // delete a category (expects {"id": ...})
  static Future Delete(data) async {
    try {
      final url = Uri.parse('$apiCategoryUrl/delete');
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

  // add a category (expects {"name": ..., "description": ...})
  static Future Add(data) async {
    try {
      final url = Uri.parse('$apiCategoryUrl/');
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
