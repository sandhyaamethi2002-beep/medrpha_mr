import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medrpha_new/screens/home_screen.dart';
import '../AppManager/ViewModel/LoginVM/login_otp_vm.dart';
import '../AppManager/ViewModel/RegistrationVM/addfirm_vm.dart';
import '../screens/otp_verify.dart';

class AddUserController extends GetxController {

  /// ---------------- STATES ----------------
  var currentStep = 0.obs;
  var isAgreed = false.obs;
  var isLoading = false.obs;
  var isPhoneVerified = false.obs;

  final LoginOtpVM loginOtpVM = Get.put(LoginOtpVM());
  final AddFirmVM addFirmVM = Get.put(AddFirmVM());

  /// ---------------- STEP 1 : PERSONAL DETAILS ----------------
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// ---------------- STEP 2 : FIRM DETAILS ----------------
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

  /// ---------------- STEP 3 : ADDRESS ----------------
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final pinCodeController = TextEditingController();
  final addressController = TextEditingController();

  /// ---------------- STEP 4 : OTHER DETAILS ----------------
  final contactPersonNameController = TextEditingController();
  final contactNumberController = TextEditingController();
  final alternateNumberController = TextEditingController();

  /// ---------------- PHONE VERIFICATION ----------------
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
        String? serverOtp = loginOtpVM.otpResponse.value?.otp;
        if (serverOtp != null && serverOtp.isNotEmpty) {
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

  /// ---------------- FILE PICKER ----------------
  Future<void> pickFile(TextEditingController controller) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null) {
      controller.text = result.files.single.path ?? "";
    }
  }

  /// ---------------- NAVIGATION ----------------
  void nextStep() {
    if (currentStep.value == 0 && !isPhoneVerified.value) {
      Get.snackbar("Action Required", "Please verify your mobile number first",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    if (currentStep.value < 3) currentStep.value++;
  }

  void previousStep() {
    if (currentStep.value > 0) currentStep.value--;
  }

  /// ---------------- SUBMIT REGISTRATION ----------------
  Future<void> submitRegistration() async {

    // Validation
    if (!isAgreed.value) {
      Get.snackbar("Terms Required", "Please accept terms and conditions",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter Name (Firm Name)",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      Map<String, String> fields = {
        "user_type_id": "1",
        "firm_name": nameController.text, // Name hi firm_name hai
        "gstno": gstNoController.text,
        "valid": DateTime.now().toIso8601String(),
        "phoneno": phoneController.text,
        "dl1": drugLicenceNoController.text,
        "dl2": drugLicenceNoController.text,
        "pic3": drugLicenceNoController.text,
        "address": addressController.text,
        "register_date": DateTime.now().toIso8601String(),
        "pay_late_status": "1",
        "txtemail": emailController.text,
        "txtpostalcode": pinCodeController.text,
        "txtdlno": drugLicenceNoController.text,
        "AdminId": "1",
        "complete_reg_status": "1",
        "countryid": "1",
        "stateid": "1",
        "cityid": "1",
        "Regionalid": "1",
        "Areaid": "1",
        "Status": "1",
        "txtdlname": drugLicenceNameController.text,
        "fssaiNo": fssaiNoController.text,
        "PersonName": contactPersonNameController.text,
        "PersonNumber": contactNumberController.text,
        "AlternateNumber": alternateNumberController.text,
        "hdnDrugsyesno": hasDrugLicence.value == "Yes" ? "1" : "0",
        "hdnFSSAI": hasFSSAI.value == "Yes" ? "1" : "0",
        "gstnoyesno": hasGST.value == "Yes" ? "1" : "0",
        "mrid": "1",
        "hftermsandconditions": isAgreed.value ? "1" : "0",
        "firmpassword": passwordController.text,
        "app_status": "1",
        "salepid": "1",
        "SalesexecutiveId": "1",
      };

      bool success = await addFirmVM.addFirm(
        fields: fields,
        dl1File: dl1Controller.text,
        dl2File: dl2Controller.text,
        pic3File: fssaiImageController.text,
      );

      if (success) {
        Get.snackbar("Success", "Registration Completed Successfully!",
            backgroundColor: Colors.green, colorText: Colors.white);

        Get.offAll(() => HomeScreen());
      }

    } catch (e) {
      Get.snackbar("Error", "Registration Failed", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------- DISPOSE ----------------
  @override
  void onClose() {
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