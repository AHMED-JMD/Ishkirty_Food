import 'dart:convert';
import 'package:http/http.dart';

String apiUrl = 'http://localhost:3000/api/admin';

class API_Auth {
  static Future Login (data) async {
    try{
      Map<String, String> ConfigHeaders = {
        "Content-Type" : "application/json"
      };

      final url = Uri.parse('$apiUrl/login');
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