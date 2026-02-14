import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? isLoggedIn = prefs.getBool('isLoggedIn');

    // Wait for 3 seconds for the splash screen to be visible
    await Future.delayed(const Duration(seconds: 3));

    if (isLoggedIn == true) {
      Get.offAllNamed('/home'); // Go to Home
    } else {
      Get.offAllNamed('/login'); // Go to Login
    }
  }
}
