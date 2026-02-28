import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../AppManager/Models/LoginM/login_model.dart';
import '../screens/home_screen.dart';


class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final useridController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  static const String loginUrl =
      "https://mrnew.medrpha.com/api/AuthApi/login";

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: "Please fill all required fields properly.",
      );
      return;
    }

    final userId = useridController.text.trim();
    final password = passwordController.text.trim();

    if (userId.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: "User Id and Password cannot be empty.",
      );
      return;
    }

    try {
      isLoading.value = true;

      Uri uri = Uri.parse(loginUrl);

      Map<String, dynamic> requestBody = {
        "userName": userId,
        "password": password,
        "role": 2,
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

      // 🔵 PRINT RESPONSE
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("=================================");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final loginResponse = LoginResponseModel.fromJson(jsonData);

        if (loginResponse.success) {
          final prefs = await SharedPreferences.getInstance();

          await prefs.setBool('isLoggedIn', true);
          await prefs.setInt(
              'userId', loginResponse.data?.userId ?? 0);
          await prefs.setString(
              'userName', loginResponse.data?.userName ?? "");

          Fluttertoast.showToast(
            msg: loginResponse.message,
          );

          Get.offAll(() => const HomeScreen());
        } else {
          Fluttertoast.showToast(
            msg: loginResponse.message,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Server Error: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("Login Error: $e");

      Fluttertoast.showToast(
        msg: "Something went wrong. Please try again.",
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    useridController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}