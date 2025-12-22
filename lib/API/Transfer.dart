import 'dart:convert';
import 'package:http/http.dart';

String apiUrl = 'http://localhost:3000/api/transfer';

class API_Transfer {
  static Future add (data) async {
    try{
      Map<String, String> ConfigHeaders = {
        "Content-Type" : "application/json"
      };

      final url = Uri.parse('$apiUrl/');
      Response response = await post(url, headers: ConfigHeaders ,body: jsonEncode(data));

      if(response.statusCode == 200){
        return true;
      }else{
        return response.body;
      }
    }catch (e){
      throw e;
    }
  }
  //get data
  static Future Get (data) async {
    try{
      Map<String, String> ConfigHeaders = {
        "Content-Type" : "application/json"
      };

      final url = Uri.parse('$apiUrl/get');
      Response response = await post(url, headers: ConfigHeaders, body: jsonEncode(data));

      return response;
    }catch (e){
      throw e;
    }
  }
  //modify data
  static Future Modify (data) async {
    try{
      Map<String, String> ConfigHeaders = {
        "Content-Type" : "application/json"
      };

      final url = Uri.parse('$apiUrl/update');
      Response response = await post(url, headers: ConfigHeaders ,body: jsonEncode(data));

      if(response.statusCode == 200){
        return true;
      }else{
        return response.body;
      }
    }catch (e){
      throw e;
    }
  }
  //modify data
  //delete data
  static Future Delete (data) async {
    try{
      Map<String, String> ConfigHeaders = {
        "Content-Type" : "application/json"
      };

      final url = Uri.parse('$apiUrl/delete');
      Response response = await post(url, headers: ConfigHeaders ,body: jsonEncode(data));

      if(response.statusCode == 200){
        return true;
      }else{
        return response.body;
      }
    }catch (e){
      throw e;
    }
  }
}