import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medrpha_new/screens/view_user_detail.dart';
import '../controllers/verified_user_controller.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';
import '../widgets/add_user_screen.dart';
import '../widgets/verified_user_card.dart';

class VerifiedUserScreen extends StatelessWidget {
  VerifiedUserScreen({super.key});

  final VerifiedUserController controller = Get.put(VerifiedUserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: whiteColor),
        title: Text("Verified Users", style: titleStyle.copyWith(color: whiteColor)),
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
        // Use a Column for the overall layout
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add User Button
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.dialog(AddUserScreen());
                    },
                    icon: const Icon(CupertinoIcons.add, color: whiteColor, size: 18),
                    label: Text("Add User", style: buttonTextStyle.copyWith(color: whiteColor)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  TextField(
                    controller: controller.searchController,
                    style: bodyStyle,
                    decoration: InputDecoration(
                      hintText: "Search by firm name...",
                      hintStyle: bodyStyle.copyWith(color: greyColor),
                      prefixIcon: const Icon(CupertinoIcons.search, color: greyColor),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none, // No border
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // User List
            Expanded(
              child: Obx(() => ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: controller.filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = controller.filteredUsers[index];
                      return VerifiedUserCard(
                        firmName: user.firmName,
                        gstNo: user.gstNo,
                        phoneNo: user.phoneNo,
                        date: user.date,
                        isActive: user.isActive,
                        onViewDetails: () {
                          Get.to(() => ViewUserDetail(user: user));
                          // TODO: Implement view details logic
                        },
                        onViewPrice: () {
                          // TODO: Implement view price logic
                        },
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
