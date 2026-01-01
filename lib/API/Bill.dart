import 'dart:convert';
import 'package:http/http.dart';

String apiUrl = 'http://localhost:3000/api/bill';

class APIBill {
  static Future Add(data) async {
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

  //get the bills
  static Future GetAll(data) async {
    try {
      Map<String, String> Headers = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/by_type');
      Response response =
          await post(url, headers: Headers, body: jsonEncode(data));

      return response;
    } catch (e) {
      print(e);
    }
  }

  //get client bills
  static Future GetClientBills(data) async {
    try {
      Map<String, String> ConfigHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/client_bills');
      Response response =
          await post(url, headers: ConfigHeaders, body: jsonEncode(data));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  //get client bills
  static Future getAdminBills(data) async {
    try {
      Map<String, String> Headers = {'Content-Type': 'application/json'};

      final url = Uri.parse('$apiUrl/admin_bills');
      Response response =
          await post(url, headers: Headers, body: jsonEncode(data));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Saerch bills in dates
  static Future Search(data) async {
    try {
      Map<String, String> ConfigHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/search_dates');
      Response response =
          await post(url, headers: ConfigHeaders, body: jsonEncode(data));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  //get bill transactions
  static Future GetBillTrans(data) async {
    try {
      Map<String, String> ConfigHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/getTrans');
      Response response =
          await post(url, headers: ConfigHeaders, body: jsonEncode(data));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  //update the bills to be deleted
  static Future deleted_update(data) async {
    try {
      Map<String, String> ConfigHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/deletd_update');
      Response response =
          await post(url, headers: ConfigHeaders, body: jsonEncode(data));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  //delete bill
  static Future deleteBill(data) async {
    try {
      Map<String, String> ConfigHeaders = {"Content-Type": "application/json"};

      final url = Uri.parse('$apiUrl/delete');
      Response response =
          await post(url, headers: ConfigHeaders, body: jsonEncode(data));

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
