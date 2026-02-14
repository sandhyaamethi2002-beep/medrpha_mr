import 'package:flutter/material.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';

class DashboardProgressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String targetLabel;
  final String targetValue;
  final double progress;

  const DashboardProgressCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.targetLabel,
    required this.targetValue,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Reduced elevation for a flatter look with border
      color: whiteColor, // Explicitly set to white
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: blackColor, width: 1.5), // Added black border
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(title, style: titleStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            // Subtitle and Target Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(subtitle, style: bodyStyle.copyWith(color: greyColor, fontSize: 14)),
                Flexible(
                  child: Text(
                    '$targetLabel $targetValue',
                    style: bodyStyle.copyWith(color: greyColor, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: greyColor.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
            const SizedBox(height: 8),

            // Percentage Text
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${(progress * 100).toStringAsFixed(0)}% Complete",
                style: bodyStyle.copyWith(color: greyColor, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
