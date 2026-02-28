import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/drawer_menu_controller.dart';
import '../screens/initial_user_screen.dart';
import '../screens/manage_user_screen.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';
import '../screens/profile_detail_screen.dart';
import 'logout_button.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});


  final DrawerMenuController menuController = Get.put(DrawerMenuController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
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
                    Get.back();
                  },
                ),

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

                Obx(() {
                  if (!menuController.mrExpanded.value) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 5.0),
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
                          title: Text("Initial User", style: bodyStyle.copyWith(fontSize: 15)),
                          onTap: () {
                            Get.back();
                            Get.to(() => InitialUserScreen());
                          },
                        ),
                        ListTile(
                          dense: true,
                          leading: const Icon(CupertinoIcons.person_crop_circle_badge_plus, size: 22, color: greyColor),
                          title: Text("Manage User", style: bodyStyle.copyWith(fontSize: 15)),
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
                  leading: const Icon(CupertinoIcons.square_arrow_left, color: Colors.red),
                  title: Text("Logout", style: buttonTextStyle.copyWith(color: Colors.red)),
                  onTap: () {
                    Get.back();

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const LogoutDialog();
                      },
                    );
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
