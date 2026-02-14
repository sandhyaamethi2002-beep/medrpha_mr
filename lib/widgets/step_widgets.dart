import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:medrpha_new/controllers/add_user_controller.dart';

import '../screens/terms_condition.dart';
import 'country_state_city_widgets.dart';

// --- Reusable Input Field ---
Widget customInputField({
  required String label,
  required TextEditingController ctr,
  required IconData icon,
  bool isPass = false,
  bool readOnly = false,
  VoidCallback? onTap,
  TextInputType keyboardType = TextInputType.text,
  Widget? suffixIcon,
  int? maxLines = 1,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: TextFormField(
      controller: ctr,
      readOnly: readOnly,
      onTap: onTap,
      obscureText: isPass,
      keyboardType: keyboardType,
      maxLines: isPass ? 1 : maxLines,
      minLines: 1,
      validator: validator ?? (value) => value!.isEmpty ? "This field is required" : null,
      style: const TextStyle(fontSize: 15), // Input text size
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade800, fontSize: 14),
        prefixIcon: Icon(icon, color: Color(0xFF1A5ED3), size: 22),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        // Vertical 16 padding taaki height dropdown se match kare
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade600, width: 1.5), // Dark grey border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1A5ED3), width: 1.5),
        ),
      ),
    ),
  );
}

// --- Reusable Yes/No Dropdown ---
Widget yesNoDropdown(String label, RxString selectedValue, List<Widget> children, IconData icon) {
  return Obx(() => Column(
    children: [
      DropdownButtonFormField<String>(
        value: selectedValue.value,
        isExpanded: true,
        style: const TextStyle(color: Colors.black, fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade800, fontSize: 14),
          prefixIcon: Icon(icon, color: Color(0xFF1A5ED3), size: 22),
          filled: true,
          fillColor: Colors.white,
          // Content padding TextField ke barabar rakhi hai
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade600, width: 1.5), // Same dark border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1A5ED3), width: 1.5),
          ),
        ),
        items: ["Yes", "No"].map((val) => DropdownMenuItem(
            value: val,
            child: Text(val, style: const TextStyle(fontWeight: FontWeight.bold))
        )).toList(),
        onChanged: (val) => selectedValue.value = val!,
      ),
      if (selectedValue.value == "Yes")
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(children: children),
        ),
      const SizedBox(height: 18),
    ],
  ));
}

// --Personal ---
class PersonalStep extends StatelessWidget {
  final AddUserController controller;
  const PersonalStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      customInputField(label: "Name *", ctr: controller.nameController, icon: CupertinoIcons.person),
      customInputField(label: "Phone No. *", ctr: controller.phoneController, icon: CupertinoIcons.phone, keyboardType: TextInputType.phone),
      customInputField(label: "Email *", ctr: controller.emailController, icon: CupertinoIcons.mail, keyboardType: TextInputType.emailAddress),
      customInputField(label: "Password *", ctr: controller.passwordController, icon: CupertinoIcons.lock, isPass: true),
    ]);
  }
}

class FirmStep extends StatelessWidget {
  final AddUserController controller;
  const FirmStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 10),

        yesNoDropdown("GST No. *", controller.hasGST, [
          customInputField(label: "GST Number *", ctr: controller.gstNoController, icon: CupertinoIcons.doc_text),
        ], CupertinoIcons.doc_text),

        yesNoDropdown("Drugs Licence *", controller.hasDrugLicence, [
          customInputField(label: "Drugs Licence Name *", ctr: controller.drugLicenceNameController, icon: CupertinoIcons.doc_text),
          customInputField(label: "Drugs Licence No. *", ctr: controller.drugLicenceNoController, icon: CupertinoIcons.doc_text),
          customInputField(label: "DL-1 *", ctr: controller.dl1Controller, icon: CupertinoIcons.doc, readOnly: true,
            suffixIcon: IconButton(icon: const Icon(CupertinoIcons.cloud_upload, color: Color(0xFF1A5ED3)),
              onPressed: () => controller.pickFile(controller.dl1Controller),
            ),
          ),

          customInputField(label: "DL-2 *", ctr: controller.dl2Controller, icon: CupertinoIcons.doc, readOnly: true,
            suffixIcon: IconButton(icon: const Icon(CupertinoIcons.cloud_upload, color: Color(0xFF1A5ED3)),
              onPressed: () => controller.pickFile(controller.dl2Controller),
            ),
          ),

          customInputField(
            label: "Valid Upto *",
            ctr: controller.validUptoController,
            icon: CupertinoIcons.calendar,
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF1A5ED3),
                        onPrimary: Colors.white,
                        onSurface: Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                // Date format: YYYY-MM-DD (Aap isse change bhi kar sakte hain)
                String formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                controller.validUptoController.text = formattedDate;
              }
            },
          ),
        ], CupertinoIcons.doc_text),

        yesNoDropdown("FSSAI *", controller.hasFSSAI, [
          customInputField(label: "FSSAI No. *", ctr: controller.fssaiNoController, icon: CupertinoIcons.shield),
          customInputField(
            label: "FSSAI Image *",
            ctr: controller.fssaiImageController,
            icon: CupertinoIcons.photo,
            readOnly: true,
            suffixIcon: IconButton(
              icon: const Icon(CupertinoIcons.cloud_upload, color: Color(0xFF1A5ED3)),
              onPressed: () => controller.pickFile(controller.fssaiImageController),
            ),
          ),
        ], CupertinoIcons.shield),
      ],
    );
  }
}

// ---  Address ---

class AddressStep extends StatelessWidget {
  final AddUserController controller;
  const AddressStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Country, State, City Selection
      CountryStateCityWidget(
        onChanged: (country, state, city) {
          controller.countryController.text = country;
          controller.stateController.text = state;
          controller.cityController.text = city;
        },
      ),
      const SizedBox(height: 18),

      // Pin Code
      customInputField(
          label: "Pin Code *",
          ctr: controller.pinCodeController,
          icon: CupertinoIcons.location,
          keyboardType: TextInputType.number
      ),

      // Address
      customInputField(
          label: "Address *",
          ctr: controller.addressController,
          icon: CupertinoIcons.house
      ),
    ]);
  }
}

// ---  Other ---


class OtherStep extends StatelessWidget {
  final AddUserController controller;
  const OtherStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      customInputField(
          label: "Contact Person Name",
          ctr: controller.contactPersonNameController,
          icon: CupertinoIcons.person_crop_circle),
      customInputField(
          label: "Number",
          ctr: controller.contactNumberController,
          icon: CupertinoIcons.device_phone_portrait,
          keyboardType: TextInputType.phone),
      customInputField(
        label: "Alternate Number",
        ctr: controller.alternateNumberController,
        icon: CupertinoIcons.phone,
        keyboardType: TextInputType.phone,
        validator: (value) => null,
      ),

      const SizedBox(height: 10),

      // --- Terms & Conditions Checkbox ---
      Obx(() => CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        value: controller.isAgreed.value,
        onChanged: (val) => controller.isAgreed.value = val!,
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Color(0xFF1A5ED3),
        title: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 14, color: Colors.black),
            children: [
              const TextSpan(text: "I agree with "),
              TextSpan(
                text: "Terms and Conditions",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  // decoration: TextDecoration.underline,
                ),

                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TermsConditionPage(),
                      ),
                    );
                  },
              ),
            ],
          ),
        ),
      )),
    ]);
  }
}