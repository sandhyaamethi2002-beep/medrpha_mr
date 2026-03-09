import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:medrpha_new/controllers/add_user_controller.dart';
import 'package:medrpha_new/widgets/yesno_dropdown_widget.dart';
import '../AppManager/Models/RegistrationM/getPincodeByCity_model.dart';
import '../AppManager/ViewModel/RegistrationVM/getCityByState_vm.dart';
import '../AppManager/ViewModel/RegistrationVM/getPincodeByCity_vm.dart';
import '../AppManager/ViewModel/RegistrationVM/getStatesByCountry_vm.dart';
import '../AppManager/ViewModel/RegistrationVM/get_country_vm.dart';
import '../screens/terms_condition.dart';
import 'add_user_inputfield.dart';

// --Personal Step ---
class PersonalStep extends StatelessWidget {
  final AddUserController controller;
  const PersonalStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              flex: 2,
              child: Obx(() {
                bool isVerified = controller.isPhoneVerified.value;

                return customInputField(
                  label: "Phone No. *",
                  ctr: controller.phoneController,
                  icon: CupertinoIcons.phone,
                  keyboardType: TextInputType.phone,

                  enable: !isVerified,

                );
              }),
            ),

            const SizedBox(width: 10),

            // Verify Button
            Obx(() {
              bool isVerified = controller.isPhoneVerified.value;

              return SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: isVerified
                      ? null
                      : () => controller.verifyPhoneNumber(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isVerified
                        ? Colors.green
                        : const Color(0xFF1A5ED3),
                    disabledBackgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: Text(
                    isVerified ? "VERIFIED" : "VERIFY",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),

        const SizedBox(height: 15),
        const Divider(),
        const SizedBox(height: 15),

        // Remaining Fields (LOCKED UNTIL VERIFIED)
        Obx(() {
          bool isVerified = controller.isPhoneVerified.value;

          return Opacity(
            opacity: isVerified ? 1.0 : 0.5,
            child: AbsorbPointer(
              absorbing: !isVerified,
              child: Column(
                children: [
                  customInputField(
                    label: "Name *",
                    ctr: controller.nameController,
                    icon: CupertinoIcons.person,
                  ),
                  customInputField(
                    label: "Email *",
                    ctr: controller.emailController,
                    icon: CupertinoIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  customInputField(
                    label: "Password *",
                    ctr: controller.passwordController,
                    icon: CupertinoIcons.lock,
                    isPass: true,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

// --- Firm Step ---
class FirmStep extends StatelessWidget {
  final AddUserController controller;
  const FirmStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),

        YesNoDropdown(
          label: "GST No. *",
          selectedValue: controller.hasGST,
          icon: CupertinoIcons.doc_text,
          children: [
            customInputField(label: "GST Number *", ctr: controller.gstNoController, icon: CupertinoIcons.doc_text),
          ],
        ),

        YesNoDropdown(
          label: "Drugs Licence *",
          selectedValue: controller.hasDrugLicence,
          icon: CupertinoIcons.doc_text,
          children: [
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
                );
                if (pickedDate != null) {
                  controller.validUptoController.text = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                }
              },
            ),
          ],
        ),

        YesNoDropdown(
          label: "FSSAI *",
          selectedValue: controller.hasFSSAI,
          icon: CupertinoIcons.shield,
          children: [
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
          ],
        ),
      ],
    );
  }
}

// --- Address Step ---
class AddressStep extends StatelessWidget {
  final AddUserController controller;

  AddressStep({super.key, required this.controller});

  final GetCountryVM countryVM = Get.put(GetCountryVM());
  final GetStatesByCountryVM stateVM = Get.put(GetStatesByCountryVM());
  final GetCityByStateVM cityVM = Get.put(GetCityByStateVM());
  final GetPincodeByCityVM pincodeVM = Get.put(GetPincodeByCityVM());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// 🔹 Country Dropdown
        Obx(() {
          if (countryVM.isLoading.value) {
            return const CircularProgressIndicator();
          }

          return DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: "Country *",
              border: OutlineInputBorder(),
              prefixIcon: Icon(CupertinoIcons.globe),
            ),
            value: countryVM.selectedCountry.value,
            items: countryVM.countryList.map((country) {
              return DropdownMenuItem(
                value: country,
                child: Text(country.countryName),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                countryVM.selectedCountry.value = value;
                controller.countryController.text = value.countryName;

                stateVM.fetchStates(value.countryId);

                /// RESET ALL BELOW
                stateVM.selectedState.value = null;
                cityVM.selectedCity.value = null;

                controller.stateController.clear();
                controller.cityController.clear();
                controller.pinCodeController.clear();

                cityVM.cityList.clear();
                pincodeVM.areaList.clear();
                pincodeVM.selectedArea.value = null;
              }
            },
          );
        }),

        const SizedBox(height: 15),

        /// 🔹 State Dropdown
        Obx(() {
          if (stateVM.isLoading.value) {
            return const CircularProgressIndicator();
          }

          return DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: "State *",
              border: OutlineInputBorder(),
              prefixIcon: Icon(CupertinoIcons.map_pin_ellipse),
            ),
            value: stateVM.selectedState.value,
            items: stateVM.stateList.map((state) {
              return DropdownMenuItem(
                value: state,
                child: Text(state.stateName),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                stateVM.selectedState.value = value;
                controller.stateController.text = value.stateName;

                cityVM.fetchCities(value.stateid);

                cityVM.selectedCity.value = null;
                controller.cityController.clear();
                controller.pinCodeController.clear();

                pincodeVM.areaList.clear();
                pincodeVM.selectedArea.value = null;
              }
            },
          );
        }),

        const SizedBox(height: 15),

        /// 🔹 City Dropdown
        Obx(() {
          if (cityVM.isLoading.value) {
            return const CircularProgressIndicator();
          }

          return DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: "City *",
              border: OutlineInputBorder(),
              prefixIcon: Icon(CupertinoIcons.location_solid),
            ),
            value: cityVM.selectedCity.value,
            items: cityVM.cityList.map((city) {
              return DropdownMenuItem(
                value: city,
                child: Text(city.cityName),
              );
            }).toList(),
            onChanged: (value) async {
              if (value != null) {
                cityVM.selectedCity.value = value;
                controller.cityController.text = value.cityName;

                controller.pinCodeController.clear();
                pincodeVM.selectedArea.value = null;

                /// CALL PINCODE API
                await pincodeVM.fetchPincode(value.cityid);

                /// Default Select First If Exists
                if (pincodeVM.areaList.isNotEmpty) {
                  pincodeVM.selectedArea.value =
                      pincodeVM.areaList.first;

                  controller.pinCodeController.text =
                      pincodeVM.areaList.first.areaName;
                }
              }
            },
          );
        }),

        const SizedBox(height: 15),

        /// 🔹 PinCode Dropdown (Multiple Support)
        Obx(() {
          if (pincodeVM.isLoading.value) {
            return const CircularProgressIndicator();
          }

          if (pincodeVM.areaList.isEmpty) {
            return customInputField(
              label: "Pin Code *",
              ctr: controller.pinCodeController,
              icon: CupertinoIcons.location,
              keyboardType: TextInputType.number,
            );
          }

          return DropdownButtonFormField<AreaData>(
            decoration: const InputDecoration(
              labelText: "Pin Code *",
              border: OutlineInputBorder(),
              prefixIcon: Icon(CupertinoIcons.location),
            ),
            value: pincodeVM.selectedArea.value,
            items: pincodeVM.areaList.map((area) {
              return DropdownMenuItem<AreaData>(
                value: area,
                child: Text(area.areaName),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                pincodeVM.selectedArea.value = value;
                controller.pinCodeController.text = value.areaName;
              }
            },
          );
        }),

        const SizedBox(height: 15),

        /// 🔹 Address
        customInputField(
          label: "Address *",
          ctr: controller.addressController,
          icon: CupertinoIcons.house,
          maxLines: 2,
        ),
      ],
    );
  }
}

// --- Other Step ---
class OtherStep extends StatelessWidget {
  final AddUserController controller;
  const OtherStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      customInputField(label: "Contact Person Name", ctr: controller.contactPersonNameController, icon: CupertinoIcons.person_crop_circle),
      customInputField(label: "Number", ctr: controller.contactNumberController, icon: CupertinoIcons.device_phone_portrait, keyboardType: TextInputType.phone),
      customInputField(label: "Alternate Number", ctr: controller.alternateNumberController, icon: CupertinoIcons.phone, keyboardType: TextInputType.phone, validator: (value) => null),
      const SizedBox(height: 10),
      Obx(() => CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        value: controller.isAgreed.value,
        onChanged: (val) => controller.isAgreed.value = val!,
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: const Color(0xFF1A5ED3),
        title: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 14, color: Colors.black),
            children: [
              const TextSpan(text: "I agree with "),
              TextSpan(
                text: "Terms and Conditions",
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                recognizer: TapGestureRecognizer()..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsConditionPage())),
              ),
            ],
          ),
        ),
      )),
    ]);
  }
}