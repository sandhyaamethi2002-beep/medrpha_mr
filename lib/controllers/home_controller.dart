import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // 1. Storage import add kiya
import '../AppManager/Models/DashboardM/installmentDetails_model.dart';
import '../AppManager/Services/DashboardS/installmentDetails_service.dart';

class HomeController extends GetxController {

  // Storage instance taaki logged-in ID nikaal saken
  final box = GetStorage();

  /// TARGETS
  final monthlyRegistrationTarget = 150.0.obs;
  final monthlySaleTarget = 500000.0.obs;

  /// TOTAL
  final totalRegistration = 0.0.obs;
  final totalSale = 0.0.obs;

  /// MONTHLY
  final monthlyRegistrationActual = 112.0.obs;
  final monthlySaleActual = 250000.0.obs;

  /// PROGRESS
  double get monthlyInstallationProgress =>
      (monthlyRegistrationActual.value / (monthlyRegistrationTarget.value == 0 ? 1 : monthlyRegistrationTarget.value))
          .clamp(0, 1);

  double get monthlySaleProgress =>
      (monthlySaleActual.value / (monthlySaleTarget.value == 0 ? 1 : monthlySaleTarget.value)).clamp(0, 1);

  /// API CALL
  Future<void> fetchInstallmentDetails(int mrid) async {
    // Debugging ke liye print laga diya taaki pata chale kaunsi ID call ho rahi hai
    print("Fetching Dashboard Data for MR ID: $mrid");

    final InstallmentDetailsModel? data =
    await InstallmentDetailsService.getInstallmentDetails(mrid);

    if (data != null) {
      /// TARGET
      // .toDouble() use karte waqt null check handling
      monthlyRegistrationTarget.value = (data.target ?? 0).toDouble();
      monthlySaleTarget.value = (data.monthlyinstallation ?? 0).toDouble();

      /// TOTAL
      totalRegistration.value = (data.totalInstallment ?? 0).toDouble();
      totalSale.value = (data.totalSale ?? 0).toDouble();

      /// MONTHLY
      monthlyRegistrationActual.value = (data.monthlyInstallment ?? 0).toDouble();
      monthlySaleActual.value = (data.monthlySale ?? 0).toDouble();
    }
  }

  @override
  void onInit() {
    super.onInit();

    // --- DYNAMIC ID LOGIC START ---
    // Storage se 'mr_id' read karein (Jo Login ke waqt save kiya tha)
    // Agar storage khali hai toh fallback ke liye 1 rakha hai
    int loggedInMrId = box.read('mr_id') ?? 1;

    // Ab wahi ID bhej rahe hain jo storage mein mili
    fetchInstallmentDetails(loggedInMrId);
    // --- DYNAMIC ID LOGIC END ---
  }
}