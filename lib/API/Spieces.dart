import 'dart:convert';
import 'package:http/http.dart';
import '../utils/businessLocation.dart';
import 'api_helpers.dart';

String apiUrl = 'http://localhost:3000/api/spieces';

class APISpieces {
  static Future add(name, price, categoryId, file) async {
    try {
      final url = Uri.parse('$apiUrl/');
      var request = MultipartRequest('POST', url);
      request.fields['name'] = name;
      request.fields['price'] = price;
      request.fields['categoryid'] = categoryId;
      final location = AuthContext.businessLocation?.toString().trim();
      if (location != null && location.isNotEmpty) {
        request.fields['business_location'] = location;
      }
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
      final url = Uri.parse('$apiUrl/');
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

  //get data
  static Future GetFavs() async {
    try {
      final url = Uri.parse('$apiUrl/favourites');
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

  //get by type data
  static Future getByType(data) async {
    try {
      final url = Uri.parse('$apiUrl/type');
      Response response = await post(
        url,
        headers: buildHeaders(),
        body: jsonEncode(attachBusinessLocation(data)),
      );

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
      final url = Uri.parse('$apiUrl/find_one');
      Response response = await post(
        url,
        headers: buildHeaders(),
        body: jsonEncode(attachBusinessLocation(data)),
      );

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
