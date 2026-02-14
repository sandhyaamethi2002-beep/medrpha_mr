import 'package:get/get.dart';

class DrawerMenuController extends GetxController {
  final mrExpanded = false.obs;

  void toggleMR() {
    mrExpanded.value = !mrExpanded.value;
  }

  // Add this method to collapse the menu
  void collapseMR() {
    mrExpanded.value = false;
  }
}
