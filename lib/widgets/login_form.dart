import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find();

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [

            //  Static Designation Field
            TextFormField(
              // initialValue: "Executive (MR)",
              controller: TextEditingController(text: "Executive (MR)"),
              readOnly: true,
              style: bodyStyle,
              decoration: InputDecoration(
                labelText: "Designation",
                labelStyle: buttonTextStyle,
                prefixIcon: const Icon(
                  CupertinoIcons.person_badge_plus,
                  color: greyColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            //  Email field
            TextFormField(
              controller: controller.useridController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              style: bodyStyle,
              decoration: InputDecoration(
                labelText: "User Id",
                labelStyle: buttonTextStyle,
                prefixIcon: const Icon(
                  CupertinoIcons.person,
                  color: greyColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your User Id';
                }
                // if (!GetUtils.isEmail(value)) {
                //   return 'Please enter a valid User Id';
                // }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // ✅ Password field
            Obx(() => TextFormField(
              controller: controller.passwordController,
              obscureText: !controller.isPasswordVisible.value,
              style: bodyStyle,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: buttonTextStyle,
                prefixIcon: const Icon(
                  CupertinoIcons.lock,
                  color: greyColor,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? CupertinoIcons.eye_slash
                        : CupertinoIcons.eye,
                    color: greyColor,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            )),
            const SizedBox(height: 15),

            // ✅ Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot Password?",
                    style: bodyStyle.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // ✅ Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  shadowColor: primaryColor.withOpacity(0.4),
                ),
                child: Text(
                  "Login",
                  style: buttonTextStyle.copyWith(
                    fontSize: 18,
                    color: whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
