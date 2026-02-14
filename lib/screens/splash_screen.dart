import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: primaryColor,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ----- LOGO -----
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Image.asset(
                      "assets/icons/img.png", // your medrpha logo
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ----- APP NAME -----
                Text(
                  "MEDRPHA",
                  style: titleStyle.copyWith(
                    color: whiteColor,
                    fontSize: 28,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "ARMC MR Portal",
                  style: bodyStyle.copyWith(
                    color: white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                // ----- LOADER -----
                const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(whiteColor),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
