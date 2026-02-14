import 'package:get/get.dart';

class DrawerStateController extends GetxController {
  var isOpen = false.obs;

  void openDrawer() => isOpen.value = true;
  void closeDrawer() => isOpen.value = false;
  void toggleDrawer() => isOpen.value = !isOpen.value;
}
