import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../Models/LoginM/verify_login_otp_model.dart';
import '../../Services/LoginS/verify_login_otp_service.dart';

class VerifyLoginOtpVM extends GetxController {
  final VerifyLoginOtpService _service = VerifyLoginOtpService();
  final box = GetStorage();

  RxBool isLoading = false.obs;
  Rxn<VerifyLoginOtpModel> verifyResponse = Rxn<VerifyLoginOtpModel>();

  Future<bool> verifyOtp(String mobileNumber, String otp) async {
    isLoading.value = true;

    final response = await _service.verifyLoginOtp(
      mobileNumber: mobileNumber,
      otp: otp,
    );

    isLoading.value = false;

    if (response != null && response.status == true) {
      verifyResponse.value = response;

      /// --- DYNAMIC ID SAVING START ---
      if (response.data != null && response.data!.mrid != null) {
        await box.write('mr_id', response.data?.mrid ?? "");

        print("Login Success! MR ID ${response.data!.mrid} saved to storage.");
      }

      return true;
    } else {
      return false;
    }
  }
}