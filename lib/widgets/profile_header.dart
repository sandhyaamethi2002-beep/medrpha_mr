import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';

class ProfileHeader extends StatefulWidget {
  final String name;
  final String role;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.role,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _showImagePickerOptions,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(45),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: _image != null
                  ? Image.file(
                _image!,
                fit: BoxFit.cover,
              )
                  : const Icon(
                Icons.person,
                size: 40,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: titleStyle.copyWith(
                    fontSize: 20,
                    color: blackColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.role,
                  style: bodyStyle.copyWith(
                    fontSize: 14,
                    color: greyColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
