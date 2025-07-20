import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image from gallery: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to take photo: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  static void showImagePickerDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                Get.find<dynamic>().pickFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                Get.find<dynamic>().pickFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }
}
