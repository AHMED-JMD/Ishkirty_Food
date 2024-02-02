import 'dart:convert';
import 'package:http/http.dart';

String apiUrl = 'http://localhost:3000/api/admin';

class APIAuth {
  static Future GetManagers () async {
    try{
      Map<String, String> ConfigHeaders = {
        "Content-Type" : "application/json"
      };

      final url = Uri.parse('$apiUrl/');
      Response response = await get(url, headers: ConfigHeaders ,);

      return response;
    }catch (e){
      throw e;
    }
  }

  static Future Login (data) async {
    try{
      Map<String, String> ConfigHeaders = {
        "Content-Type" : "application/json"
      };

      final url = Uri.parse('$apiUrl/login');
      Response response = await post(url, headers: ConfigHeaders ,body: jsonEncode(data));

      return response;
    }catch (e){
      throw e;
    }
  }

  static Future Register (data) async {
    try{
      Map<String, String> ConfigHeaders = {
        "Content-Type" : "application/json"
      };

      final url = Uri.parse('$apiUrl/register');
      Response response = await post(url, headers: ConfigHeaders ,body: jsonEncode(data));

      return response;
    }catch (e){
      throw e;
    }
  }

  static Future UpdatPassword (data) async {
    try{
      Map<String, String> ConfigHeaders = {
        "Content-Type" : "application/json"
      };

      final url = Uri.parse('$apiUrl/update_password');
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

  static Future DeleteManager (data) async {
    try{
      Map<String, String> ConfigHeaders = {
        "Content-Type" : "application/json"
      };

      final url = Uri.parse('$apiUrl/delete-user');
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