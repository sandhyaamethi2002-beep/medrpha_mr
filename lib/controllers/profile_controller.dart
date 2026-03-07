import 'package:get/get.dart';

class ProfileController extends GetxController {
  final name = "John Doe".obs;
  final role = "SMR".obs;
  final mrId = "12345".obs;
  final designation = "Senior Medical Representative".obs;
  final phone = "+1 123 456 7890".obs;
  final address = "MEDRPHA Noida Sec-6 India".obs;

  void logout() {
    // Implement logout functionality
  }
}
