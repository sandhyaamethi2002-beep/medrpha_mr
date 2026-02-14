import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/home_screen.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final useridController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;

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

    // Basic check (optional but better)
    if (userId.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: "User Id and Password cannot be empty.",
      );
      return;
    }

    // Save login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    Get.offAll(() => const HomeScreen());
  }

  @override
  void onClose() {
    useridController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
