import 'package:get/get.dart';

class HomeController extends GetxController {
  // Data for the first progress card
  final monthlyRegistrationTarget = 150.0.obs;
  final monthlyRegistrationActual = 112.0.obs;

  double get monthlyInstallationProgress =>
      (monthlyRegistrationActual.value / monthlyRegistrationTarget.value).clamp(0, 1);

  // Data for the second progress card
  final monthlySaleTarget = 500000.0.obs;
  final monthlySaleActual = 250000.0.obs;

  double get monthlySaleProgress =>
      (monthlySaleActual.value / monthlySaleTarget.value).clamp(0, 1);
}
