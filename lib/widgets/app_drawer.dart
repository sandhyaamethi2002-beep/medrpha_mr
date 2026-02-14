import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/drawer_menu_controller.dart';
import '../controllers/logout_controller.dart';
import '../screens/unverified_user_screen.dart';
import '../screens/verified_user_screen.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';
import '../screens/profile_detail_screen.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  final LogoutController logoutController = Get.put(LogoutController());
  final DrawerMenuController menuController = Get.put(DrawerMenuController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Updated Drawer Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: const BoxDecoration(
              color: primaryColor,
            ),
            child: Column(
              children: [
                const SizedBox(height: 30),
                CircleAvatar(
                  radius: 38,
                  backgroundColor: whiteColor,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(36),
                    child: Image.asset(
                      "assets/images/logo.png",
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "User Name",
                  style: titleStyle.copyWith(fontSize: 18, color: whiteColor),
                ),
                const SizedBox(height: 4),
                Text(
                  "user.name@example.com",
                  style: bodyStyle.copyWith(fontSize: 14, color: white70),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(CupertinoIcons.home, color: blackColor),
                  title: Text("MR Dashboard", style: buttonTextStyle),
                  onTap: () {
                    Get.back(); // Close drawer
                  },
                ),
                // This is now a reactive, expandable tile
                Obx(() => ListTile(
                      leading: const Icon(CupertinoIcons.person_2_alt, color: blackColor),
                      title: Text("MR", style: buttonTextStyle),
                      trailing: Icon(
                        menuController.mrExpanded.value
                            ? CupertinoIcons.chevron_down
                            : CupertinoIcons.chevron_right,
                        size: 20,
                        color: blackColor,
                      ),
                      onTap: () {
                        menuController.toggleMR();
                      },
                    )),

                // This Column will only be visible when the menu is expanded
                Obx(() {
                  if (!menuController.mrExpanded.value) {
                    return const SizedBox.shrink(); // Hidden when not expanded
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 5.0), // Further increased indentation
                    child: Column(
                      children: [
                        ListTile(
                          dense: true,
                          leading: const Icon(CupertinoIcons.person, size: 22, color: greyColor),
                          title: Text("View Profile", style: bodyStyle.copyWith(fontSize: 15)),
                          onTap: () {
                            Get.back();
                            Get.to(() => ProfileDetailScreen());
                          },
                        ),
                        ListTile(
                          dense: true,
                          leading: const Icon(CupertinoIcons.check_mark_circled, size: 22, color: greyColor),
                          title: Text("Unverified User", style: bodyStyle.copyWith(fontSize: 15)),
                          onTap: () {
                            Get.back();
                            Get.to(() => UnverifiedUserScreen());
                          },
                        ),
                        ListTile(
                          dense: true,
                          leading: const Icon(CupertinoIcons.person_crop_circle_badge_plus, size: 22, color: greyColor),
                          title: Text("Verified User", style: bodyStyle.copyWith(fontSize: 15)),
                          onTap: () {
                            Get.back();
                            Get.to(() => VerifiedUserScreen());
                          },
                        ),
                      ],
                    ),
                  );
                }),

                const Divider(height: 20, indent: 15, endIndent: 15),

                // Logout Button
                ListTile(
                  leading: const Icon(CupertinoIcons.power, color: Colors.red),
                  title: Text("Logout", style: buttonTextStyle.copyWith(color: Colors.red)),
                  onTap: () {
                    logoutController.logout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
