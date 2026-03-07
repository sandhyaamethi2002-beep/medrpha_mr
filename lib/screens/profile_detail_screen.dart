import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_card.dart';
import '../controllers/profile_controller.dart';

class ProfileDetailScreen extends StatelessWidget {
  ProfileDetailScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor, // 1. Set background color
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: whiteColor),
        elevation: 0,
        title: Text(
          "Profile Details",
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
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ⭐ Profile Header
                Container(
                  width: double.infinity,
                  height: 150,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: greyColor.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ProfileHeader(
                      name: controller.name.value,
                      role: controller.role.value,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ⭐ User Info Cards
                ProfileInfoCard(
                  label: "MR Id",
                  value: controller.mrId.value,
                ),
                const SizedBox(height: 20),
                ProfileInfoCard(
                  label: "Designation",
                  value: controller.designation.value,
                ),
                const SizedBox(height: 20),
                ProfileInfoCard(label: "Phone", value: controller.phone.value),
                const SizedBox(height: 20),
                ProfileInfoCard(
                  label: "Address",
                  value: controller.address.value,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
