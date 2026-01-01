import 'dart:convert';
import 'package:http/http.dart';

String apiUrl = 'http://localhost:3000/api/spieces';

class APISpieces {
  static Future add(name, price, category, file) async {
    try {
      final url = Uri.parse('$apiUrl/');
      var request = MultipartRequest('POST', url);
      request.fields['name'] = name;
      request.fields['price'] = price;
      request.fields['category'] = category;
      request.files.add(await MultipartFile.fromPath(
        'file',
        file.path,
        // Set the appropriate content type
      ));

      var response = await request.send();
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  //get data
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

  //get data
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

  //get by type data
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

  //get by type data
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

  //modify data
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

  //delete data
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
