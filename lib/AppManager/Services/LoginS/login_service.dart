import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/LoginM/login_model.dart';

class LoginService {

  static const String baseUrl =
      "https://mrnew.medrpha.com/api/AuthApi/login";

  Future<LoginResponseModel?> login({
    required String userName,
    required String password,
    required int role,
  }) async {
    try {
      Uri uri = Uri.parse(baseUrl);

      Map<String, dynamic> requestBody = {
        "userName": userName,
        "password": password,
        "role": role,
      };

      // 🔵 PRINT URI
      print("=========== LOGIN API ===========");
      print("URI: $uri");

      // 🔵 PRINT REQUEST
      print("Request Body: ${jsonEncode(requestBody)}");

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      // 🔵 PRINT RESPONSE STATUS
      print("Status Code: ${response.statusCode}");

      // 🔵 PRINT RESPONSE BODY
      print("Response Body: ${response.body}");
      print("=================================");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return LoginResponseModel.fromJson(jsonData);
      } else {
        print("Login Failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }
}