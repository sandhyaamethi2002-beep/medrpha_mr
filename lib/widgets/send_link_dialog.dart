import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../AppManager/ViewModel/InitialUserVM/SaveInitialUser_vm.dart';
import '../AppManager/Models/InitialUserM/GetInitialRegistrationsByMrId_model.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';
import '../controllers/initial_user_controller.dart';

class SendLinkDialog extends StatelessWidget {
  SendLinkDialog({super.key});

  // These will find the existing controllers or create them if they don't exist
  final SaveInitialUserVM vm = Get.put(SaveInitialUserVM());
  final InitialUserController controller = Get.put(InitialUserController());

  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Send Link", style: titleStyle.copyWith(fontSize: 18)),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(CupertinoIcons.xmark, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Body
            Row(
              children: [
                Text(
                  "Phone No.",
                  style: bodyStyle.copyWith(color: Colors.black),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: bodyStyle,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: primaryColor, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// Footer
            const Divider(color: Colors.grey, thickness: 0.5),
            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /// Send Button
                Obx(() => ElevatedButton(
                  onPressed: vm.isLoading.value
                      ? null
                      : () async {
                    String phone = phoneController.text.trim();

                    if (phone.isEmpty) return;

                    // Logic check using the controller we just fetched
                    bool exists = controller.vm.users.any((u) => u.phoneno == phone);

                    if (exists) {
                      Get.snackbar(
                        "Duplicate",
                        "This number is already added!",
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                      );
                      return;
                    }

                    // Send number via API
                    UserData? newUser = await vm.sendLink(phone);

                    if (newUser != null) {
                      vm.newUser.value = newUser;
                      Get.back(); // Close dialog on success

                      Get.snackbar(
                          "Success",
                          "Link sent successfully!",
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: vm.isLoading.value
                      ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: whiteColor,
                    ),
                  )
                      : Text(
                    "Send",
                    style: buttonTextStyle.copyWith(color: whiteColor),
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}