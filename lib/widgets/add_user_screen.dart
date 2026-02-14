import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medrpha_new/widgets/step_widgets.dart';

import '../controllers/add_user_controller.dart';




class AddUserScreen extends StatelessWidget {
  AddUserScreen({super.key});

  final AddUserController controller = Get.put(AddUserController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Registration",
            style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20)),
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Color(0xFF1A5ED3),
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: List.generate(4, (index) =>
                      _buildTab(
                          index, ["Personal", "Firm", "Address", "Other"][index])
                  ),
                ),
                const SizedBox(height: 30),

                // --- Dynamic Steps Section ---
                Expanded(
                  child: SingleChildScrollView(
                    child: Obx(() {
                      return Column(
                        children: [
                          _getStepWidget(controller.currentStep.value),
                          const SizedBox(height: 25),
                          _buildNavigationButtons(),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Step selector logic
  Widget _getStepWidget(int step) {
    switch (step) {
      case 0:
        return PersonalStep(controller: controller);
      case 1:
        return FirmStep(controller: controller);
      case 2:
        return AddressStep(controller: controller);
      case 3:
        return OtherStep(controller: controller);
      default:
        return const SizedBox();
    }
  }

  Widget _buildTab(int index, String title) {
    return Obx(() {
      bool isActive = controller.currentStep.value == index;
      return Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ?  Color(0xFF1A5ED3) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(title, textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10,
                  color: isActive ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.bold)),
        ),
      );
    });
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _navButton("Previous", () => controller.previousStep(), isPrimary: false),
        _navButton(
            controller.currentStep.value == 3 ? "Finish" : "Next",
                () {
              // Validation Logic
              if (_formKey.currentState!.validate()) {
                if (controller.currentStep.value == 3) {
                  // Last step par checkbox check karein
                  if (!controller.isAgreed.value) {
                    Get.snackbar("Terms Required", "Please agree to Terms & Conditions",
                        backgroundColor: Colors.orange, colorText: Colors.white);
                    return;
                  }
                  controller.submitRegistration();
                } else {
                  controller.nextStep();
                }
              }
            },
            isPrimary: true
        ),
      ],
    );
  }

  Widget _navButton(String label, VoidCallback? onPressed,
      {required bool isPrimary}) {
    bool isDisabled = !isPrimary && controller.currentStep.value == 0;

    return SizedBox(
      width: 120,
      height: 45,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? Colors.grey.shade400 : Color(0xFF1A5ED3),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: isDisabled ? 0 : 2,
        ),
        child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
        ),
      ),
    );
  }
}