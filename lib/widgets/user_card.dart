import 'package:flutter/material.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';

class UserCard extends StatelessWidget {
  final int serialNumber;
  final String phoneNumber;
  final VoidCallback onComplete;

  const UserCard({
    super.key,
    required this.serialNumber,
    required this.phoneNumber,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Serial Number
            SizedBox(
              width: 50,
              child: Text(
                serialNumber.toString(),
                style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            // Phone Number
            Expanded(
              child: Text(
                phoneNumber,
                style: bodyStyle,
                textAlign: TextAlign.center,
              ),
            ),

            // Complete Button
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: onComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text("Complete", style: buttonTextStyle.copyWith(color: whiteColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
