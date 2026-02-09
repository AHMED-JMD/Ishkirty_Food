import 'dart:convert';
import 'package:http/http.dart';
import 'api_helpers.dart';

String storeApiUrl = 'http://localhost:3000/api/store';

class APIStore {
  static Future getItems(data) async {
    try {
      final url = Uri.parse('$storeApiUrl/');
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

  static Future addItem(data) async {
    try {
      final url = Uri.parse('$storeApiUrl/add');
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

  static Future updateItem(data) async {
    try {
      final url = Uri.parse('$storeApiUrl/update');
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

  static Future deleteItem(data) async {
    try {
      final url = Uri.parse('$storeApiUrl/delete');
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

  /// Store spices
  static Future getStoreSpice(String spiceId) async {
    try {
      final url = Uri.parse('$storeApiUrl/store-items');
      final body = jsonEncode(attachBusinessLocation({'id': spiceId}));
      Response response = await post(
        url,
        headers: buildHeaders(),
        body: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future addStoreSpice(data) async {
    try {
      final url = Uri.parse('$storeApiUrl/addStoreSpices');
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

  static Future deleteStoreSpice(data) async {
    try {
      final url = Uri.parse('$storeApiUrl/deleteStoreSpice');
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

  // Purchases
  static Future getPurchases() async {
    try {
      final url = Uri.parse('$storeApiUrl/purchase');
      Response response = await get(url, headers: buildHeaders());
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future getPurchasesByDate(data) async {
    try {
      final url = Uri.parse('$storeApiUrl/purchase/date');
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

  static Future addPurchase(data) async {
    try {
      final url = Uri.parse('$storeApiUrl/purchase');
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

  static Future deletePurchase(data) async {
    try {
      final url = Uri.parse('$storeApiUrl/purchase/delete');
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
