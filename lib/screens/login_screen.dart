import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../styles/color_styles.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---------- HEADER ----------
            LoginHeader(),

            // ---------- LOGIN FORM ----------
            SizedBox(height: 40),
            Icon(CupertinoIcons.person_fill, size: 70, color: greyColor),
            LoginForm(),

            // ---------- FOOTER ----------
            // SignUpFooter(),

            SizedBox(height: 20), // Add some bottom padding
          ],
        ),
      ),
    );
  }
}
