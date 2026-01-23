import 'dart:convert';
import 'package:http/http.dart';

String apiUrl = 'http://localhost:3000/api/sales';

class APISales {
//get the sales today
  static Future TodaySales(data) async {
    try {
      Map<String, String> configHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/today_sales');
      Response response =
          await post(url, headers: configHeaders, body: jsonEncode(data));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future todayCosts(data) async {
    try {
      Map<String, String> configHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/today_costs');
      Response response =
          await post(url, headers: configHeaders, body: jsonEncode(data));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  //get speices sales
  static Future SpeicesSales(data) async {
    try {
      Map<String, String> configHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/spieces_sales');
      Response response =
          await post(url, headers: configHeaders, body: jsonEncode(data));

      return response;
    } catch (e) {
      return e;
    }
  }

  //get all speices sales
  static Future allSpeicesSales(data) async {
    try {
      Map<String, String> configHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/all_spieces_sales');
      Response response =
          await post(url, headers: configHeaders, body: jsonEncode(data));

      return response;
    } catch (e) {
      return e;
    }
  }

  //get speices searched sales
  static Future SearchedSales(data) async {
    try {
      Map<String, String> ConfigHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/searched_sales');
      Response response =
          await post(url, headers: ConfigHeaders, body: jsonEncode(data));

      return response;
    } catch (e) {
      return e;
    }
  }
}
