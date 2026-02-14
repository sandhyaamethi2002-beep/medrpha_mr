import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/unverified_user_controller.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';
import '../widgets/send_link_dialog.dart';

class UnverifiedUserScreen extends StatelessWidget {
  UnverifiedUserScreen({super.key});

  final UnverifiedUserController controller = Get.put(UnverifiedUserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: whiteColor),
        title: Text("Unverified Users", style: titleStyle.copyWith(color: whiteColor)),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                children: [
                  // Send Link Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      onPressed: () => Get.dialog(const SendLinkDialog()),
                      icon: const Icon(CupertinoIcons.add, color: whiteColor, size: 18),
                      label: Text("Send Link", style: buttonTextStyle.copyWith(color: whiteColor)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  TextField(
                    controller: controller.searchController,
                    style: bodyStyle,
                    decoration: InputDecoration(
                      hintText: "Search...",
                      hintStyle: bodyStyle.copyWith(color: greyColor),
                      prefixIcon: const Icon(CupertinoIcons.search, color: greyColor),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // User List
            Expanded(
              child: Obx(() {
                if (controller.filteredUsers.isEmpty) {
                  return const Center(child: Text("No users found."));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: controller.filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = controller.filteredUsers[index];
                    final serialNumber = index + 1;
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 10),
                      color: const Color(0xFFF5F5F5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 40,
                              child: Text(serialNumber.toString(), style: bodyStyle),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(user.phone, style: bodyStyle),
                            ),
                            ElevatedButton(
                              onPressed: user.isCompleted ? null : () => controller.completeRegistration(user),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: user.isCompleted ? Colors.grey : Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(user.isCompleted ? "Done" : "Complete", style: buttonTextStyle.copyWith(color: whiteColor)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
