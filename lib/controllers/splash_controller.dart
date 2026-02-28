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

    await Future.delayed(const Duration(seconds: 3));

    if (isLoggedIn == true) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }
}
