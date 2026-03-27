import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../AppManager/Models/LoginM/login_model.dart';
import '../screens/home_screen.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final useridController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  // Storage instance
  final box = GetStorage();

  static const String loginUrl = "https://mrnew.medrpha.com/api/AuthApi/login";

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please fill all required fields properly.");
      return;
    }

    final userId = useridController.text.trim();
    final password = passwordController.text.trim();

    if (userId.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: "User Id and Password cannot be empty.");
      return;
    }

    try {
      isLoading.value = true;

      Uri uri = Uri.parse(loginUrl);
      Map<String, dynamic> requestBody = {
        "userName": userId,
        "password": password,
        "role": 2, // Ye request parameter hai, isse chhedne ki zaroorat nahi
      };

      print("=========== LOGIN API ===========");
      print("URI: $uri");
      print("Request Body: ${jsonEncode(requestBody)}");

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("=================================");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final loginResponse = LoginResponseModel.fromJson(jsonData);

        if (loginResponse.success) {

          // 1. User ki ID nikalen
          int mrid = loginResponse.data?.userId ?? 0;

          // 2. ✅ DYNAMIC USER TYPE ID:
          // Hum response ke 'data' object se userTypeId utha rahe hain.
          // Agar response mein field ka naam 'roleId' ya kuch aur hai, toh bas niche badal dein.
          int dynamicUserTypeId = loginResponse.data?.userTypeId ?? 2;

          // Sab kuch storage mein save karein
          await box.write('mr_id', mrid);
          await box.write('isLoggedIn', true);
          await box.write('userName', loginResponse.data?.userName ?? "");

          // ✅ Ab hamesha wahi ID save hogi jo API ne bheji hai
          await box.write('userTypeId', dynamicUserTypeId);

          print("✅ Storage Updated: Saved mr_id = $mrid, userTypeId = $dynamicUserTypeId");

          Fluttertoast.showToast(msg: loginResponse.message ?? "Login Successful");

          // Navigate to Home
          Get.offAll(() => const HomeScreen());
        } else {
          Fluttertoast.showToast(msg: loginResponse.message ?? "Login Failed");
        }
      } else {
        Fluttertoast.showToast(msg: "Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Login Error: $e");
      Fluttertoast.showToast(msg: "Something went wrong. Please try again.");
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