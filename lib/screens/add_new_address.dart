import 'package:flutter/material.dart';

void showAddAddressBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const AddAddressWidget(),
  );
}

class AddAddressWidget extends StatefulWidget {
  const AddAddressWidget({super.key});

  @override
  State<AddAddressWidget> createState() => _AddAddressWidgetState();
}

class _AddAddressWidgetState extends State<AddAddressWidget> {
  String selectedType = "Home";

  // Aapka Brand Color
  final Color primaryColor = const Color(0xFF1A5ED3);

  @override
  Widget build(BuildContext context) {
    // Keyboard open hone par padding adjust karne ke liye
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// --- Header Section ---
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 10, top: 15),
            child: _buildHeader(context),
          ),
          const Divider(thickness: 1, height: 1),

          /// --- Form Section ---
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: keyboardHeight + 20, // Keyboard ke upar content rahega
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      "Select address type",
                      style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _typeChip(Icons.home_rounded, "Home"),
                      _typeChip(Icons.work_rounded, "Office"),
                      _typeChip(Icons.add_location_alt_rounded, "Other"),
                    ],
                  ),
                  const SizedBox(height: 25),

                  _buildTextField("Receiver's name *", Icons.person_outline),
                  _buildTextField("Complete address *", Icons.location_on_outlined),
                  _buildTextField("Nearby Landmark (optional)", Icons.map_outlined),
                  _buildTextField("Mobile Number *", Icons.phone_android_outlined, isNumber: true),

                  const SizedBox(height: 10),
                  _buildSaveButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Address details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded, color: Colors.black54),
        )
      ],
    );
  }

  Widget _typeChip(IconData icon, String label) {
    bool isSelected = selectedType == label;
    return GestureDetector(
      onTap: () => setState(() => selectedType = label),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? primaryColor : Colors.grey.shade300,
              width: 1.2
          ),
          boxShadow: isSelected ? [
            BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))
          ] : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 20, color: Colors.grey.shade400),
          labelText: label,
          floatingLabelStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
          shadowColor: primaryColor.withOpacity(0.5),
        ),
        child: const Text(
          "SAVE ADDRESS",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
    );
  }
}