import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../AppManager/ViewModel/ProfileVM/get_mr_by_id_vm.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_card.dart';

class ProfileDetailScreen extends StatelessWidget {
  final int mrId;

  ProfileDetailScreen({super.key, required this.mrId});

  final controller = Get.put(GetMrByIdController());

  @override
  Widget build(BuildContext context) {

    // API call
    controller.fetchMr(mrId);

    return Scaffold(
      backgroundColor: primaryColor,
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
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = controller.mrData.value;

            if (data == null) {
              return const Center(child: Text("No Data Found"));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
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
                      name: data.mrNm ?? "",
                      role: "MR",
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                ProfileInfoCard(
                  label: "MR Id",
                  value: data.mrid.toString(),
                ),

                const SizedBox(height: 20),

                ProfileInfoCard(
                  label: "Phone",
                  value: data.mrmobile ?? "",
                ),

                const SizedBox(height: 20),

                ProfileInfoCard(
                  label: "Designation",
                  value:  (data.hdnDes_id == 2 ) ? 'Executive' : 'Team-Leader',
                ),

                const SizedBox(height: 20),

                ProfileInfoCard(
                  label: "Address",
                  value: data.mrAddress ?? "",
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
