import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/LoginM/login_otp_model.dart';

class LoginOtpService {
  static const String baseUrl =
      "https://mrnew.medrpha.com/api/AuthApi/send-login-otp";

  Future<LoginOtpModel?> sendLoginOtp(String mobileNumber) async {
    try {
      final uri = Uri.parse(baseUrl);

      final body = {
        "mobileNumber": mobileNumber,
      };

      // 🔹 PRINT URI
      print(" URI: $uri");

      // 🔹 PRINT REQUEST
      print(" Request Body: ${jsonEncode(body)}");

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      // 🔹 PRINT RESPONSE STATUS
      print(" Response Status Code: ${response.statusCode}");

      // 🔹 PRINT RESPONSE BODY
      print(" Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return LoginOtpModel.fromJson(jsonData);
      } else {
        print(" API Failed");
        return null;
      }
    } catch (e) {
      print(" Error: $e");
      return null;
    }
  }
}