import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/LoginM/verify_login_otp_model.dart';

class VerifyLoginOtpService {

  Future<VerifyLoginOtpModel?> verifyLoginOtp({
    required String mobileNumber,
    required String otp,
  }) async {

    final Uri uri = Uri.parse(
        "https://mrnew.medrpha.com/api/AuthApi/verify-login-otp");

    final Map<String, dynamic> body = {
      "mobileNumber": mobileNumber,
      "otp": otp,
    };

    try {
      //  PRINT URI
      print("REQUEST URI: $uri");

      //  PRINT REQUEST BODY
      print("REQUEST BODY: ${jsonEncode(body)}");

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      //  PRINT RESPONSE STATUS
      print("RESPONSE STATUS CODE: ${response.statusCode}");

      //  PRINT RESPONSE BODY
      print("RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return VerifyLoginOtpModel.fromJson(jsonData);
      } else {
        print("API FAILED");
        return null;
      }
    } catch (e) {
      print("ERROR: $e");
      return null;
    }
  }
}