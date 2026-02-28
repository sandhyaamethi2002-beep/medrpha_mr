import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../styles/text_styles.dart';

class ViewUserDetail extends StatelessWidget {
  final dynamic user;

  const ViewUserDetail({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // ⭐ Dialog height fix
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TITLE
            Text(
              user.firmName?.toString() ?? "N/A",
              style: titleStyle.copyWith(fontSize: 20),
            ),

            const SizedBox(height: 20),

            /// DETAILS
            _row("Firm Name :", user.firmName),
            _row("Phone :", user.phoneNo),
            _row("GST :", user.gstNo),
            _row("Email :", "N/A"),
            _row("Status :", user.isActive ? "Active" : "Inactive"),

            const SizedBox(height: 25),

            /// DL BOXES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _docBox("DL1"),
                _docBox("DL2"),
              ],
            ),

            const SizedBox(height: 30),

            /// CLOSE BUTTON
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey.shade700,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// INFO ROW
  Widget _row(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              title,
              style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? "N/A",
              style: bodyStyle,
            ),
          ),
        ],
      ),
    );
  }

  /// DOCUMENT BOX
  Widget _docBox(String title) {
    return Column(
      children: [
        const Icon(Icons.description, size: 32, color: Colors.grey),
        const SizedBox(height: 6),
        Text(title, style: bodyStyle),
      ],
    );
  }
}