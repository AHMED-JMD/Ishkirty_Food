import 'dart:convert';
import 'dart:html' as html;
import 'package:http/http.dart';

String apiUrl = 'http://localhost:3000/api/spieces';

class APIWebSpieces {
  static Future add(name, price, categoryId, file) async {
    try {
      final url = '$apiUrl/';
      final formData = html.FormData();
      formData.append('name', name);
      formData.append('price', price);
      formData.append('categoryid', categoryId);

      // Support multiple possible file shapes returned by file pickers on web.
      try {
        if (file is html.File) {
          formData.appendBlob('file', file, file.name);
        } else if (file != null && (file.bytes != null)) {
          final blob = html.Blob([file.bytes]);
          formData.appendBlob('file', blob, file.name ?? 'file');
        } else if (file is Map && file['bytes'] != null) {
          final blob = html.Blob([file['bytes']]);
          formData.appendBlob('file', blob, file['name'] ?? 'file');
        } else {
          // Fallback: attempt to append as-is
          formData.append('file', file);
        }
      } catch (e) {
        // ignore and attempt to append generically
        formData.append('file', file);
      }

      final request = await html.HttpRequest.request(url,
          method: 'POST', sendData: formData, requestHeaders: {});

      if (request.status == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future Get() async {
    try {
      Map<String, String> ConfigHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/');
      Response response = await get(url, headers: ConfigHeaders);

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

  static Future GetFavs() async {
    try {
      Map<String, String> configHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/favourites');
      Response response = await get(url, headers: configHeaders);

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

  static Future getByType(data) async {
    try {
      Map<String, String> configHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/type');
      Response response =
          await post(url, headers: configHeaders, body: jsonEncode(data));

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

  static Future findOne(data) async {
    try {
      Map<String, String> configHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/find_one');
      Response response =
          await post(url, headers: configHeaders, body: jsonEncode(data));

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

  static Future update(data) async {
    try {
      Map<String, String> configHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/update');
      Response response =
          await post(url, headers: configHeaders, body: jsonEncode(data));

      if (response.statusCode == 200) {
        return true;
      } else {
        return response.body;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future Delete(data) async {
    try {
      Map<String, String> configHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/delete');
      Response response =
          await post(url, headers: configHeaders, body: jsonEncode(data));

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
