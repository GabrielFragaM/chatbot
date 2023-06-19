import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {

  static String baseUrl = '';

  static Future<Map<String, String>> getHeaders({required bool getToken}) async {
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Access-Control_Allow_Origin': '*',
    };

    return headers;
  }

  static Future<Map<String, dynamic>>makePost({String? path, required Map<String, dynamic> body, required bool getToken}) async {
    String url = baseUrl;
    if(path != null){
      url = '$url/$path';
    }

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: await getHeaders(getToken: getToken),
    );

    if(response.statusCode == 200){
      final Map<String, dynamic> body = jsonDecode(response.body);
      return {
        'success': true,
        'content': body
      };
    }else{
      return {
        'success': false,
        'content': response.body
      };
    }
  }


  factory ApiServices() => ApiServices._internal();
  ApiServices._internal();
}