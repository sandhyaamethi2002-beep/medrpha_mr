import 'package:get/get.dart';
import '../../Models/LoginM/verify_login_otp_model.dart';
import '../../Services/LoginS/verify_login_otp_service.dart';

class VerifyLoginOtpVM extends GetxController {

  final VerifyLoginOtpService _service = VerifyLoginOtpService();

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
      return true;
    } else {
      return false;
    }
  }
}