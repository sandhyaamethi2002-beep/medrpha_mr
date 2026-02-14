import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';
import '../widgets/image_picker_widget.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final EditProfileController controller =
  Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: whiteColor),
        elevation: 0,
        title: Text(
          "Edit Profile",
          style: titleStyle.copyWith(color: whiteColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // 👤 Profile Image
              Obx(() => ImagePickerWidget(
                image: controller.selectedImage.value, onTap: () {  },
              )),

              const SizedBox(height: 20),

              // 📷 Camera & Gallery Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.pickFromCamera,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        CupertinoIcons.camera,
                        color: whiteColor,
                      ),
                      label: Text(
                        "Camera",
                        style: buttonTextStyle.copyWith(
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.pickFromGallery,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        CupertinoIcons.photo,
                        color: whiteColor,
                      ),
                      label: Text(
                        "Gallery",
                        style: buttonTextStyle.copyWith(
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // 💾 Save Button
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton.icon(
              //     onPressed: controller.saveProfile,
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: primaryColor,
              //       padding:
              //       const EdgeInsets.symmetric(vertical: 16),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //       elevation: 5,
              //     ),
              //     icon: const Icon(
              //       CupertinoIcons.check_mark_circled,
              //       color: whiteColor,
              //     ),
              //     label: Text(
              //       "Save Changes",
              //       style: buttonTextStyle.copyWith(
              //         fontSize: 18,
              //         color: whiteColor,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
