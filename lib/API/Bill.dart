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
  static Future GetAll () async {
    try{
      Map<String, String> ConfigHeaders = {
        "Content-Type" : "application/json"
      };

      final url = Uri.parse('$apiUrl/');
      Response response = await get(url, headers: ConfigHeaders);

      return response;
    }catch (e){
      throw e;
    }
  }

}