import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogoutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5, // Added shadow
          shadowColor: primaryColor.withOpacity(0.4),
        ),
        icon: const Icon(CupertinoIcons.power, color: whiteColor),
        label: Text(
          "Logout",
          style: buttonTextStyle.copyWith(fontSize: 18, color: whiteColor),
        ),
      ),
    );
  }
}
