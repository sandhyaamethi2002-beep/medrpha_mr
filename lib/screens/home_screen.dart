import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';
import '../widgets/add_user_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/dashboard_summary_card.dart';
import '../widgets/dashboard_progress_card.dart';
import '../widgets/send_link_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      drawer: AppDrawer(),
      backgroundColor: primaryColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: whiteColor),
        elevation: 0,
        backgroundColor: primaryColor,
        automaticallyImplyLeading: true,

        // Custom Title Row
        title: Row(
          children: [
            const SizedBox(width: 10),

            // Dashboard Title
            Expanded(
              child: Text(
                "DASHBOARD",
                style: titleStyle.copyWith(color: whiteColor),
              ),
            ),

            const SizedBox(width: 10),

            // ✅ Add Customer Dropdown Button
            PopupMenuButton<String>(
              color: Colors.white,
              offset: const Offset(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onSelected: (value) {
                if (value == "add_user") {
                  Get.dialog( AddUserScreen());
                } else if (value == "send_link") {
                  Get.dialog(const SendLinkDialog());
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: "add_user",
                  child: Text("Add User"),
                ),
                PopupMenuItem(
                  value: "send_link",
                  child: Text("Send Link"),
                ),
              ],
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black26),
                ),
                child: const Text(
                  "Add Customer",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
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
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              // -------- GRID CARDS --------
              Obx(() => GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.25,
                children: [
                  DashboardSummaryCard(
                    icon: CupertinoIcons.group_solid,
                    title: "MONTHLY REGISTRATION TARGET",
                    value: controller.monthlyRegistrationTarget.value
                        .toStringAsFixed(0),
                    color: const Color(0xFFE0F2F1),
                  ),
                  DashboardSummaryCard(
                    icon: CupertinoIcons.list_bullet,
                    title: "MONTHLY SALE TARGET",
                    value: controller.monthlySaleTarget.value
                        .toStringAsFixed(0),
                    color: const Color(0xFFFFF3E0),
                  ),
                  DashboardSummaryCard(
                    icon: CupertinoIcons.group_solid,
                    title: "TOTAL REGISTRATION",
                    value: controller.monthlyRegistrationActual.value
                        .toStringAsFixed(0),
                    color: const Color(0xFFF3E5F5),
                  ),
                  DashboardSummaryCard(
                    icon: CupertinoIcons.list_bullet,
                    title: "TOTAL SALE",
                    value: controller.monthlySaleActual.value
                        .toStringAsFixed(0),
                    color: const Color(0xFFE8F5E9),
                  ),
                  DashboardSummaryCard(
                    icon: CupertinoIcons.group_solid,
                    title: "MONTHLY REGISTRATION",
                    value: controller.monthlyRegistrationActual.value
                        .toStringAsFixed(0),
                    color: const Color(0xFFE3F2FD),
                  ),
                  DashboardSummaryCard(
                    icon: CupertinoIcons.list_bullet,
                    title: "MONTHLY SALE",
                    value: controller.monthlySaleActual.value
                        .toStringAsFixed(0),
                    color: const Color(0xFFF1F8E9),
                  ),
                ],
              )),

              const SizedBox(height: 25),

              // -------- REGISTRATION PROGRESS --------
              Obx(() => DashboardProgressCard(
                title: "Monthly Registration",
                subtitle: "Monthly Registration:",
                targetLabel: "Target:",
                targetValue: controller
                    .monthlyRegistrationTarget.value
                    .toStringAsFixed(0),
                progress: controller.monthlyInstallationProgress
              )),

              const SizedBox(height: 20),

              // -------- SALE PROGRESS --------
              Obx(() => DashboardProgressCard(
                title: "Monthly Sale",
                subtitle: "Monthly Sale:",
                targetLabel: "Target:",
                targetValue: controller.monthlySaleTarget.value
                    .toStringAsFixed(0),
                progress: controller.monthlySaleProgress,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
