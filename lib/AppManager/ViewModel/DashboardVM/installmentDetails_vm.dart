import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../Models/DashboardM/installmentDetails_model.dart';
import '../../Services/DashboardS/installmentDetails_service.dart';

class InstallmentDetailsVM extends GetxController {
  var isLoading = false.obs;
  final box = GetStorage();

  Rx<InstallmentDetailsModel?> installmentDetails =
  Rx<InstallmentDetailsModel?>(null);

  Future<void> getInstallmentDetails(int mrid) async {
    isLoading.value = true;
    final data = await InstallmentDetailsService.fetchInstallmentDetails(mrid);
    if (data != null) {
      installmentDetails.value = data;
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    int loggedInMrId = box.read('mrid') ?? 0;

    if (loggedInMrId != 0) {
      getInstallmentDetails(loggedInMrId);
    } else {
      print("Error: No MR ID found in storage");
    }
  }
}