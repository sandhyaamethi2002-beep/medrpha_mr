import 'package:flutter/material.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';

class HomeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const HomeCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: blackColor.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: whiteColor),
            const SizedBox(height: 10),
            Text(
              label,
              style: buttonTextStyle.copyWith(color: whiteColor, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
