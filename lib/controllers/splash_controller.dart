import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    final box = GetStorage();

    bool isLoggedIn = box.read('isLoggedIn') ?? false;

    Timer(const Duration(seconds: 3), () {
      if (isLoggedIn) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/login');
      }
    });
  }
}