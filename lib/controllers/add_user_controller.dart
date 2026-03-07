import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../AppManager/ViewModel/LoginVM/login_otp_vm.dart';
import '../screens/otp_verify.dart';

class AddUserController extends GetxController {
  // --- States ---
  var currentStep = 0.obs;
  var isAgreed = false.obs;
  var isLoading = false.obs;
  var isPhoneVerified = false.obs;

  final LoginOtpVM loginOtpVM = Get.put(LoginOtpVM());

  // --- STEP 1: Personal Details ---
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // --- STEP 2: Firm Details ---
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

  // --- STEP 3: Address Details ---
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final pinCodeController = TextEditingController();
  final addressController = TextEditingController();

  // --- STEP 4: Other Details ---
  final contactPersonNameController = TextEditingController();
  final contactNumberController = TextEditingController();
  final alternateNumberController = TextEditingController();

  // --- ✅ FIXED Verification Method ---
  Future<void> verifyPhoneNumber() async {
    String phone = phoneController.text.trim();

    if (phone.length != 10) {
      Get.snackbar("Error", "Please enter a valid 10 digit number",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      bool success = await loginOtpVM.sendOtp(phone);
      isLoading.value = false;

      if (success) {
        // API response se sirf OTP nikalna (baaki data ignore karna)
        String? serverOtp = loginOtpVM.otpResponse.value?.otp;

        if (serverOtp != null && serverOtp.isNotEmpty) {
          // Agar OTP mila hai toh Verification Screen par bhejein
          var result = await Get.to(() => OtpVerification(
            mobileNumber: phone,
            otp: serverOtp,
          ));

          if (result == true) {
            isPhoneVerified.value = true;
            Get.snackbar("Verified", "Mobile number verified successfully",
                backgroundColor: Colors.green, colorText: Colors.white);
          }
        } else {
          // Agar OTP nahi aaya (Already Registered case)
          Get.snackbar("Notice", "Number already registered. Please login or use another number.",
              backgroundColor: Colors.orange, colorText: Colors.white);
        }
      } else {
        Get.snackbar("Error", "Failed to send OTP",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Something went wrong",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // --- File Picker ---
  Future<void> pickFile(TextEditingController controller) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null) {
      // Path store karein taaki API mein bhej sakein (Sirf name se upload nahi hoga)
      controller.text = result.files.single.path ?? result.files.single.name;
    }
  }

  // --- Navigation ---
  void nextStep() {
    if (currentStep.value == 0 && !isPhoneVerified.value) {
      Get.snackbar("Action Required", "Please verify your mobile number first",
          backgroundColor: Colors.orange, colorText: Colors.white);
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

  // --- Final Submit (Placeholder for Firm API) ---
  Future<void> submitRegistration() async {
    if (!isAgreed.value) {
      Get.snackbar("Terms Required", "Please accept terms and conditions",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      // Yahan aap apni Add Firm API ka call karenge
      await Future.delayed(const Duration(seconds: 2));
      Get.snackbar("Success", "Registration Completed Successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Registration failed",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Memory leak se bachne ke liye controllers dispose karein
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    firmNameController.dispose();
    gstNoController.dispose();
    drugLicenceNameController.dispose();
    drugLicenceNoController.dispose();
    dl1Controller.dispose();
    dl2Controller.dispose();
    validUptoController.dispose();
    fssaiNoController.dispose();
    fssaiImageController.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    pinCodeController.dispose();
    addressController.dispose();
    contactPersonNameController.dispose();
    contactNumberController.dispose();
    alternateNumberController.dispose();
    super.onClose();
  }
}