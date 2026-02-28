import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../AppManager/ViewModel/LoginVM/login_otp_vm.dart';
import '../screens/otp_verify.dart';

class AddUserController extends GetxController {

  /// STEP TRACKER
  var currentStep = 0.obs;
  var isAgreed = false.obs;
  var isLoading = false.obs;
  var isPhoneVerified = false.obs;

  final LoginOtpVM loginOtpVM = Get.put(LoginOtpVM());

  /// STEP 1
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// STEP 2
  final firmNameController = TextEditingController();
  var hasGST = "Yes".obs;
  final gstNoController = TextEditingController();
  var hasDrugLicence = "Yes".obs;
  final drugLicenceNameController = TextEditingController();
  final drugLicenceNoController = TextEditingController();
  final dl1Controller = TextEditingController();
  final dl2Controller = TextEditingController();
  final validUptoController = TextEditingController();
  var hasFSSAI = "Yes".obs;
  final fssaiNoController = TextEditingController();
  final fssaiImageController = TextEditingController();

  /// STEP 3
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final pinCodeController = TextEditingController();
  final addressController = TextEditingController();

  /// STEP 4
  final contactPersonNameController = TextEditingController();
  final contactNumberController = TextEditingController();
  final alternateNumberController = TextEditingController();

  /// ================================
  /// ✅ FIXED OTP FUNCTION
  /// ================================

  Future<void> verifyPhoneNumber() async {

    String phone = phoneController.text.trim();

    if (phone.length != 10) {
      Get.snackbar(
        "Error",
        "Enter valid 10 digit mobile number",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      bool success = await loginOtpVM.sendOtp(phone);

      isLoading.value = false;

      if (success) {

        /// OTP Screen Open
        final result = await Get.to(() => OtpVerification(
          mobileNumber: phone,
          otp: loginOtpVM.otpResponse.value?.otp ?? "",
        ));

        /// If OTP Verified
        if (result == true) {
          isPhoneVerified.value = true;

          Get.snackbar(
            "Verified",
            "Mobile number verified successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }

      } else {
        Get.snackbar(
          "Error",
          "OTP sending failed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

    } catch (e) {
      isLoading.value = false;

      Get.snackbar(
        "Error",
        "Something went wrong",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// FILE PICKER
  Future<void> pickFile(TextEditingController controller) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null) {
      controller.text = result.files.single.name;
    }
  }

  /// STEP NAVIGATION
  void nextStep() {

    if (currentStep.value == 0 && !isPhoneVerified.value) {
      Get.snackbar(
        "Action Required",
        "Please verify mobile number first",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  /// FINAL SUBMIT
  void submitRegistration() {

    if (!isAgreed.value) {
      Get.snackbar(
        "Terms Required",
        "Please accept terms and conditions",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    Get.snackbar(
      "Success",
      "Registration Completed Successfully",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  /// Dispose Controllers
  @override
  void onClose() {

    final controllers = [
      nameController,
      phoneController,
      emailController,
      passwordController,
      firmNameController,
      gstNoController,
      drugLicenceNameController,
      drugLicenceNoController,
      dl1Controller,
      dl2Controller,
      validUptoController,
      fssaiNoController,
      fssaiImageController,
      countryController,
      stateController,
      cityController,
      pinCodeController,
      addressController,
      contactPersonNameController,
      contactNumberController,
      alternateNumberController,
    ];

    for (var c in controllers) {
      c.dispose();
    }

    super.onClose();
  }
}