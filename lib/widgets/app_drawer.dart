import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import '../AppManager/ViewModel/ProfileVM/get_mr_by_id_vm.dart';
import '../AppManager/ViewModel/RegistrationVM/get_firm_by_mrid_vm.dart';
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

  final GetMrByIdController mrController = Get.put(GetMrByIdController());

  final box = GetStorage();

  int get mrId => box.read('mr_id') ?? 0;

  @override
  Widget build(BuildContext context) {
    if (mrController.mrData.value == null) {
      mrController.fetchMr(mrId);
    }

    return Drawer(
      child: Column(
        children: [
          Obx(() {
            final userData = mrController.mrData.value;

            return Container(
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

                  // Dynamic User Name (Using mrNm)
                  Text(
                    mrController.isLoading.value
                        ? "Loading..."
                        : (userData?.mrNm ?? "User Name"),
                    style: titleStyle.copyWith(fontSize: 18, color: whiteColor),
                  ),

                  const SizedBox(height: 4),

                  // Dynamic Email (Using mremail)
                  Text(
                    mrController.isLoading.value
                        ? "Please wait..."
                        : (userData?.mremail ?? "user.name@example.com"),
                    style: bodyStyle.copyWith(fontSize: 16, color: white70),
                  ),
                ],
              ),
            );
          }),

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
                            Get.to(() => ProfileDetailScreen(mrId: mrId));
                          },
                        ),
                        ListTile(
                          dense: true,
                          leading: const Icon(CupertinoIcons.check_mark_circled, size: 22, color: greyColor),
                          title: Text("Initial User", style: bodyStyle.copyWith(fontSize: 15)),
                          onTap: () {
                            Get.back();
                            Get.to(() => InitialUserScreen(mrId: mrId));
                          },
                        ),
                        ListTile(
                          dense: true,
                          leading: const Icon(
                            CupertinoIcons.person_crop_circle_badge_plus,
                            size: 22,
                            color: greyColor,
                          ),
                          title: Text(
                            "Manage User",
                            style: bodyStyle.copyWith(fontSize: 15),
                          ),
                          onTap: () {
                            Get.back();
                            Get.to(
                                  () => ChangeNotifierProvider(
                                create: (_) => GetFirmByMridVM(),
                                child: VerifiedUserScreen(mrId: mrId),
                              ),
                            );
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