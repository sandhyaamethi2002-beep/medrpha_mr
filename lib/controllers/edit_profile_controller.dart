import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    nameController.text = "User Name";
    phoneController.text = "+91 12345 67890";
    addressController.text = "123, Flutter Lane, Dart City";
    super.onInit();
  }

  // 📷 Pick from Camera
  Future<void> pickFromCamera() async {
    PermissionStatus status = await Permission.camera.request();

    if (status.isGranted) {
      final XFile? image =
      await _picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } else {
      _showPermissionMessage();
    }
  }

  // 🖼 Pick from Gallery
  Future<void> pickFromGallery() async {
    PermissionStatus status = await Permission.photos.request();

    if (status.isGranted) {
      final XFile? image =
      await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } else {
      _showPermissionMessage();
    }
  }

  void _showPermissionMessage() {
    Get.snackbar(
      "Permission Required",
      "Please allow permission from settings.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void saveProfile() {
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
