import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadTextField extends StatefulWidget {
  final String label;

  const UploadTextField({
    super.key,
    required this.label,
  });

  @override
  State<UploadTextField> createState() => _UploadTextFieldState();
}

class _UploadTextFieldState extends State<UploadTextField> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? selectedImage;

  Future<void> pickImage() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
        _controller.text = image.name; // file name show karega
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.label,
        filled: true,
        fillColor: Colors.grey.shade100,
        prefixIcon: const Icon(
          CupertinoIcons.doc,
          size: 20,
          color: Colors.blue,
        ),
        suffixIcon: IconButton(
          icon: const Icon(
            CupertinoIcons.cloud_upload,
            color: Colors.blue,
          ),
          onPressed: pickImage,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}
