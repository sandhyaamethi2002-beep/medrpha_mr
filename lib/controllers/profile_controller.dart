import 'package:get/get.dart';

class ProfileController extends GetxController {
  final name = "John Doe".obs;
  final role = "Flutter Developer".obs;
  final userId = "12345".obs;
  final designation = "Senior Developer".obs;
  final phone = "+1 123 456 7890".obs;
  final address = "123, Flutter Lane, Dart Ville".obs;

  void logout() {
    // Implement logout functionality
  }
}
