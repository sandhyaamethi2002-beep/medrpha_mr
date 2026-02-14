import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddUserController extends GetxController {
  // --- Step Tracker ---
  var currentStep = 0.obs;
  var isAgreed = false.obs;
  var isLoading = false.obs;

  // --- STEP 1: Personal Details ---
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // --- STEP 2: Firm Details ---
  final firmNameController = TextEditingController();

  // GST Section
  var hasGST = "Yes".obs;
  final gstNoController = TextEditingController();

  // Drug Licence Section
  var hasDrugLicence = "Yes".obs;
  final drugLicenceNameController = TextEditingController();
  final drugLicenceNoController = TextEditingController();
  final dl1Controller = TextEditingController();
  final dl2Controller = TextEditingController();
  final validUptoController = TextEditingController();

  // FSSAI Section
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

  Future<void> pickFile(TextEditingController controller) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null) {
      controller.text = result.files.single.name;

      // Future API upload ke liye useful
      print("Picked File Path: ${result.files.single.path}");
    }
  }

  // --- Navigation Logic ---
  void nextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  // --- Final Submission Logic ---
  Future<void> submitRegistration() async {
    // 1. Check if Terms are agreed
    if (!isAgreed.value) {
      Get.snackbar("Terms Required", "Please accept terms and conditions",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(15),
        borderRadius: 10,
        duration: const Duration(seconds: 3),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      return;
    }

    // 2. Start Loading
    isLoading.value = true;

    try {
      print("Sending Data to Server...");
      print("Name: ${nameController.text}");
      print("Email: ${emailController.text}");


      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar("Success", "Registration Completed Successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);


    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    final allControllers = [
      nameController, phoneController, emailController, passwordController,
      firmNameController, gstNoController, drugLicenceNameController,
      drugLicenceNoController, dl1Controller, dl2Controller,
      validUptoController, fssaiNoController, fssaiImageController,
      countryController, stateController, cityController,
      pinCodeController, addressController, contactPersonNameController,
      contactNumberController, alternateNumberController
    ];

    for (var controller in allControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}