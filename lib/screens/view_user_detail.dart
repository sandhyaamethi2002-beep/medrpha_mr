import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';

class ViewUserDetail extends StatelessWidget {
  final dynamic user; // Aapka user model

  const ViewUserDetail({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text("User Full Details", style: titleStyle.copyWith(color: Colors.white)),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // --- Header Card (Firm Name & Status) ---
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(0.1),
                      child: Icon(CupertinoIcons.building_2_fill, color: primaryColor),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.firmName, style: titleStyle.copyWith(fontSize: 18)),
                          Text(user.isActive ? "Active User" : "Inactive",
                              style: bodyStyle.copyWith(color: user.isActive ? Colors.green : Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // --- Details Sections ---
              _buildInfoSection("Basic Information", [
                _infoTile(CupertinoIcons.person, "Owner Name", user.name ?? "N/A"),
                _infoTile(CupertinoIcons.phone, "Phone Number", user.phoneNo),
                _infoTile(CupertinoIcons.mail, "Email Address", user.email ?? "N/A"),
              ]),

              _buildInfoSection("Business Details", [
                _infoTile(CupertinoIcons.doc_text, "GST Number", user.gstNo),
                _infoTile(CupertinoIcons.capsule, "Drug License", user.drugLicenceNo ?? "N/A"),
                _infoTile(CupertinoIcons.shield, "FSSAI Number", user.fssaiNo ?? "N/A"),
              ]),

              _buildInfoSection("Location", [
                _infoTile(CupertinoIcons.location, "Address", user.address ?? "N/A"),
                _infoTile(CupertinoIcons.map, "City/State", "${user.city}, ${user.state}"),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  // Section Wrapper
  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle.copyWith(fontSize: 16, color: primaryColor)),
        const SizedBox(height: 10),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Column(children: children),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Individual Row
  Widget _infoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, size: 20, color: Colors.grey.shade600),
      title: Text(label, style: bodyStyle.copyWith(color: Colors.grey, fontSize: 12)),
      subtitle: Text(value, style: bodyStyle.copyWith(fontWeight: FontWeight.w600, color: Colors.black)),
    );
  }
}