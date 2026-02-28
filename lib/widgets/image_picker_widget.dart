import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../styles/color_styles.dart';

class ImagePickerWidget extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;

  const ImagePickerWidget({super.key, this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: greyColor.withOpacity(0.1),
            backgroundImage: image != null ? FileImage(image!) : null,
            child: image == null
                ? const Icon(
                    CupertinoIcons.person_fill,
                    size: 70,
                    color: greyColor,
                  )
                : null,
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.pencil,
                  size: 20,
                  color: whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
