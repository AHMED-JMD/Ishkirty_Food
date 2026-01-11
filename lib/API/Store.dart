import 'dart:convert';
import 'package:http/http.dart';

String storeApiUrl = 'http://localhost:3000/api/store';

class APIStore {
  static Future getItems() async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      final url = Uri.parse('$storeApiUrl/');
      Response response = await get(url, headers: headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future addItem(data) async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      final url = Uri.parse('$storeApiUrl/add');
      Response response =
          await post(url, headers: headers, body: jsonEncode(data));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future updateItem(data) async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      final url = Uri.parse('$storeApiUrl/update');
      Response response =
          await post(url, headers: headers, body: jsonEncode(data));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future deleteItem(data) async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      final url = Uri.parse('$storeApiUrl/delete');
      Response response =
          await post(url, headers: headers, body: jsonEncode(data));
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
