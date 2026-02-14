import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';

class VerifiedUserCard extends StatelessWidget {
  final String firmName;
  final String gstNo;
  final String phoneNo;
  final String date;
  final bool isActive;
  final VoidCallback onViewDetails;
  final VoidCallback onViewPrice;

  const VerifiedUserCard({
    super.key,
    required this.firmName,
    required this.gstNo,
    required this.phoneNo,
    required this.date,
    required this.isActive,
    required this.onViewDetails,
    required this.onViewPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: whiteColor,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header with Firm Name and View Button ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Firm Name", style: bodyStyle.copyWith(color: greyColor, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(firmName, style: titleStyle.copyWith(fontSize: 17, fontWeight: FontWeight.bold)),
                  ],
                ),
                GestureDetector(
                  onTap: onViewDetails,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.eye, size: 16, color: primaryColor),
                        const SizedBox(width: 6),
                        Text("View", style: buttonTextStyle.copyWith(color: primaryColor, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 25, thickness: 1),

            // --- Info Rows ---
            _buildInfoRow("GST No.", gstNo),
            const SizedBox(height: 12),
            _buildInfoRow("Phone No.", phoneNo),
            const SizedBox(height: 12),
            _buildInfoRow("Date", date),
            const Divider(height: 25, thickness: 1),

            // --- Footer with Status and View Price Button ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center, // Corrected: Use crossAxisAlignment
              children: [
                Row(
                  children: [
                    Text("Status", style: bodyStyle.copyWith(color: greyColor, fontSize: 14)),
                    const SizedBox(width: 10),
                    _buildStatusBadge(),
                  ],
                ),
                ElevatedButton(
                  onPressed: onViewPrice,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text("View Price", style: buttonTextStyle.copyWith(color: whiteColor, fontSize: 14)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build a row of information
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: bodyStyle.copyWith(color: greyColor, fontSize: 14)),
        Text(value, style: buttonTextStyle.copyWith(fontSize: 15, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // Helper widget to build the status badge
  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isActive ? "Active" : "Inactive",
        style: buttonTextStyle.copyWith(
          color: isActive ? Colors.green.shade800 : Colors.red.shade800,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
