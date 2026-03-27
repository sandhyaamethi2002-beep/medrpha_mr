import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFilterWidget extends StatelessWidget {
  final DateTime? fromDate;
  final DateTime? toDate;
  final Function(bool isFromDate) onPickDate;
  final Color primaryColor;

  const DateFilterWidget({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.onPickDate,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildDateButton(
            label: fromDate == null
                ? "From Date"
                : DateFormat('dd-MM-yyyy').format(fromDate!),
            icon: Icons.calendar_month_outlined,
            onTap: () => onPickDate(true),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildDateButton(
            label: toDate == null
                ? "To Date"
                : DateFormat('dd-MM-yyyy').format(toDate!),
            icon: Icons.calendar_month_outlined,
            onTap: () => onPickDate(false),
          ),
        ),
      ],
    );
  }

  Widget _buildDateButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style:
                const TextStyle(fontSize: 13, color: Colors.black87)),
            Icon(icon, size: 18, color: primaryColor),
          ],
        ),
      ),
    );
  }
}