import 'package:flutter/material.dart';
import 'package:get/get.dart';

class YesNoDropdown extends StatelessWidget {
  final String label;
  final RxString selectedValue;
  final List<Widget> children;
  final IconData icon;

  const YesNoDropdown({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.children,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        DropdownButtonFormField<String>(
          value: selectedValue.value,
          isExpanded: true,
          style: const TextStyle(color: Colors.black, fontSize: 15),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey.shade800, fontSize: 14),
            prefixIcon: Icon(icon, color: const Color(0xFF1A5ED3), size: 22),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade600, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1A5ED3), width: 1.5),
            ),
          ),
          items: ["Yes", "No"].map((val) => DropdownMenuItem(
              value: val,
              child: Text(val, style: const TextStyle(fontWeight: FontWeight.bold))
          )).toList(),
          onChanged: (val) => selectedValue.value = val!,
        ),
        if (selectedValue.value == "Yes")
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(children: children),
          ),
        const SizedBox(height: 18),
      ],
    ));
  }
}