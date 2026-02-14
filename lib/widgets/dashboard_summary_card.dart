import 'package:flutter/material.dart';
import '../styles/text_styles.dart';

class DashboardSummaryCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String value;

  const DashboardSummaryCard({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Row: Icon and Value
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Colors.black54, size: 28),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black54, width: 1),
                  ),
                  child: Text(
                    value,
                    style: buttonTextStyle.copyWith(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            // Bottom Text
            Text(
              title,
              style: bodyStyle.copyWith(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
