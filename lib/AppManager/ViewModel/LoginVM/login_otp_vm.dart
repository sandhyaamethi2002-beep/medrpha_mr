import 'package:get/get.dart';
import '../../Models/LoginM/login_otp_model.dart';
import '../../Services/LoginS/login_otp_service.dart';

class LoginOtpVM extends GetxController {
  final LoginOtpService _service = LoginOtpService();

  var isLoading = false.obs;
  var otpResponse = Rxn<LoginOtpModel>();

  Future<bool> sendOtp(String mobileNumber) async {
    isLoading.value = true;

    final response = await _service.sendLoginOtp(mobileNumber);

    isLoading.value = false;

    if (response != null && response.status == true) {
      otpResponse.value = response;
      return true;
    } else {
      Get.snackbar(
        "Error",
        response?.message ?? "Failed to send OTP",
      );
      return false;
    }
  }
}