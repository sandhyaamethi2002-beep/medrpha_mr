import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medrpha_new/screens/product_screen.dart';
import '../controllers/initial_user_controller.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';
import '../widgets/add_user_screen.dart';
import '../widgets/send_link_dialog.dart';

class InitialUserScreen extends StatelessWidget {
  final int mrId;

  InitialUserScreen({super.key, required this.mrId});

  // Updated to match the new empty constructor
  late final InitialUserController controller = Get.put(InitialUserController());

  @override
  Widget build(BuildContext context) {
    // Refresh list every time we enter the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchUsers();
    });

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: whiteColor),
        title: Text(
          "Initial Users",
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
        child: Column(
          children: [
            /// Top Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                children: [
                  /// Send Link Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      onPressed: () => Get.dialog(SendLinkDialog()),
                      icon: const Icon(
                        CupertinoIcons.add,
                        color: whiteColor,
                        size: 18,
                      ),
                      label: Text(
                        "Send Link",
                        style: buttonTextStyle.copyWith(color: whiteColor),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Search Bar
                  TextField(
                    controller: controller.searchController,
                    style: bodyStyle,
                    decoration: InputDecoration(
                      hintText: "Search phone number...",
                      hintStyle: bodyStyle.copyWith(color: greyColor),
                      prefixIcon:
                      const Icon(CupertinoIcons.search, color: greyColor),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// User List
            Expanded(
              child: Obx(() {
                if (controller.vm.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.filteredUsers.isEmpty) {
                  return Center(
                    child: Text(
                      "No Users Found",
                      style: bodyStyle.copyWith(color: greyColor),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: controller.filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = controller.filteredUsers[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(.15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Phone
                          Text(
                            user.phoneno ?? "",
                            style: bodyStyle.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          /// Complete Button
                          ElevatedButton(
                            onPressed: () {
                              Get.to(() => ProductScreen(
                                firmName: '',
                                firmId: 1,
                                userId: 1,
                                roleId: 1,
                                userTypeId: 1,
                                isViewOnly: true,
                                isSearch: true,
                                phoneno: user.phoneno,
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text(
                              "Complete",
                              style: buttonTextStyle.copyWith(
                                color: whiteColor,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
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