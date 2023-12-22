import 'dart:convert';
import 'package:http/http.dart';

String apiUrl = 'http://localhost:3000/api/bill';

class APIBill {
  static Future Add (data) async {
    try{
      Map<String, String> ConfigHeaders = {
        "Content-Type" : "application/json"
      };

      final url = Uri.parse('$apiUrl/');
      Response response = await post(url, headers: ConfigHeaders ,body: jsonEncode(data));

      return response;
    }catch (e){
      throw e;
    }
  }
  //get the bills
  static Future GetAll (data) async {
    try{
      Map<String, String> ConfigHeaders = {
        "Content-Type" : "application/json"
      };

      final url = Uri.parse('$apiUrl/by_type');
      Response response = await post(url, headers: ConfigHeaders, body: jsonEncode(data));

      return response;
    }catch (e){
      throw e;
    }
  }
  //get the bills
  static Future GetClientBills (data) async {
    try{
      Map<String, String> ConfigHeaders = {
        "Content-Type" : "application/json"
      };

      final url = Uri.parse('$apiUrl/client_bills');
      Response response = await post(url, headers: ConfigHeaders, body: jsonEncode(data));

      return response;
    }catch (e){
      throw e;
    }
  }
  //update the bills to be deleted
  static Future deleted_update (data) async {
    try{
      Map<String, String> ConfigHeaders = {
        "Content-Type" : "application/json"
      };

      final url = Uri.parse('$apiUrl/deletd_update');
      Response response = await post(url, headers: ConfigHeaders, body: jsonEncode(data));

      return response;
    }catch (e){
      throw e;
    }
  }
  //Saerch bills in dates
  static Future Search (data) async {
    try{
      Map<String, String> ConfigHeaders = {
        "Content-Type" : "application/json"
      };

      final url = Uri.parse('$apiUrl/search_dates');
      Response response = await post(url, headers: ConfigHeaders, body: jsonEncode(data));

      return response;
    }catch (e){
      throw e;
    }
  }
  //get bill transactions
  static Future GetBillTrans (data) async {
    try{
      Map<String, String> ConfigHeaders = {
        "Content-Type" : "application/json"
      };

      final url = Uri.parse('$apiUrl/getTrans');
      Response response = await post(url, headers: ConfigHeaders, body: jsonEncode(data));

      return response;
    }catch (e){
      throw e;
    }
  }

}