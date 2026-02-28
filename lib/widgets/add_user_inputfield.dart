import 'package:flutter/material.dart';

Widget customInputField({
  required String label,
  required TextEditingController ctr,
  required IconData icon,
  bool isPass = false,
  bool enable = true,
  bool readOnly = false,
  VoidCallback? onTap,
  TextInputType keyboardType = TextInputType.text,
  Widget? suffixIcon,
  int? maxLines = 1,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: TextFormField(
      controller: ctr,
      readOnly: readOnly,
      enabled: enable,
      onTap: onTap,
      obscureText: isPass,
      keyboardType: keyboardType,
      maxLines: isPass ? 1 : maxLines,
      minLines: 1,
      validator: validator ?? (value) => value!.isEmpty ? "This field is required" : null,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade800, fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF1A5ED3), size: 22),
        suffixIcon: suffixIcon,
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
    ),
  );
}