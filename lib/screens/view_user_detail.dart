import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medrpha_new/AppManager/Models/RegistrationM/get_firm_by_mrid_model.dart';
import '../styles/text_styles.dart';
import '../styles/color_styles.dart';

class ViewUserDetail extends StatelessWidget {
  final FirmData user;

  const ViewUserDetail({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// TITLE
              Center(
                child: Text(
                  user.firmName ?? "N/A",
                  style: titleStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// DETAILS
              _row("Firm Name", user.firmName),
              _row("Phone", user.phoneno),
              _row("GST No", user.gstno),
              _row("Email", "N/A"),

              const SizedBox(height: 10),

              /// STATUS
              Row(
                children: [
                  SizedBox(
                    width: 130,
                    child: Text(
                      "Status",
                      style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  _statusBadge(),
                ],
              ),

              const SizedBox(height: 25),

              /// DL BOXES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _docBox("DL1"),
                  _docBox("DL2"),
                ],
              ),

              const SizedBox(height: 25),

              /// CLOSE BUTTON (RIGHT SIDE + SMALL)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 8),
                    minimumSize: const Size(0, 35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Close",
                    style: buttonTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
              "$title :",
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

  /// STATUS BADGE
  Widget _statusBadge() {
    bool active = user.status == 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        active ? "Active" : "Inactive",
        style: TextStyle(
          color: active ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// DOCUMENT BOX
  Widget _docBox(String title) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.description,
            size: 28,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: bodyStyle,
        ),
      ],
    );
  }
}