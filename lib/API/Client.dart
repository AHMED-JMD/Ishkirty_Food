import 'dart:convert';
import 'package:http/http.dart';

String apiUrl = 'http://localhost:3000/api/client';

class APIClient {
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
  static Future Get () async {
    try{
      Map<String, String> ConfigHeaders = {
        "Content-Type" : "application/json"
      };

      final url = Uri.parse('$apiUrl/');
      Response response = await get(url, headers: ConfigHeaders);

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data;
      }else{
        return false;
      }
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

      final url = Uri.parse('$apiUrl/modify');
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
  static Future FindOne (data) async {
    try{
      Map<String, String> ConfigHeaders = {
        "Content-Type" : "application/json"
      };

      final url = Uri.parse('$apiUrl/find_one');
      Response response = await post(url, headers: ConfigHeaders ,body: jsonEncode(data));

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data;
      }else{
        return false;
      }
    }catch (e){
      throw e;
    }
  }
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