import 'package:get/get.dart';
import '../screens/login_screen.dart';

class LogoutController extends GetxController {
  void logout() {
    // Here, you would typically clear any user session data, tokens, etc.
    // For this example, we'll just navigate back to the login screen.
    Get.offAll(() => LoginScreen());
  }
}
