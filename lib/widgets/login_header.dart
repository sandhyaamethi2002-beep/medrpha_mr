import 'package:flutter/material.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              "assets/images/img.png",
              height: 90,
              width: 90,

            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Welcome Back!",
            style: titleStyle.copyWith(color: whiteColor, fontSize: 26),
          ),
          const SizedBox(height: 8),
          Text(
            "Sign in to continue",
            style: bodyStyle.copyWith(color: white70, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
