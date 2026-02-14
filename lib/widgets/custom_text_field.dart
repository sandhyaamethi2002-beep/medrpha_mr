import 'package:flutter/material.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? icon;
  final TextInputType? keyboardType;
  final bool isObscure;
  final bool readOnly;
  final int? maxLines;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.icon,
    this.keyboardType,
    this.isObscure = false,
    this.readOnly = false,
    this.maxLines = 1, // Default to a single line
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isObscure,
      readOnly: readOnly,
      maxLines: maxLines,
      style: bodyStyle,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              // Use a generic message if the label contains a ' *'
              if (labelText.trim().endsWith('*')) {
                return 'This field is required';
              }
            }
            return null; // No error
          },
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: buttonTextStyle,
        prefixIcon: icon != null ? Icon(icon, color: Colors.blue, size: 20) : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }
}
