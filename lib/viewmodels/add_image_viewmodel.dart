import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/image_picker_service.dart';
import '../viewmodels/gallery_viewmodel.dart';

class AddImageViewModel extends GetxController {
  final Rx<File?> selectedImage = Rx<File?>(null);
  final TextEditingController labelController = TextEditingController();
  final RxBool isUploading = false.obs;

  @override
  void onClose() {
    labelController.dispose();
    super.onClose();
  }

  // Pick image from gallery
  Future<void> pickFromGallery() async {
    final File? image = await ImagePickerService.pickImageFromGallery();
    if (image != null) {
      selectedImage.value = image;
    }
  }

  // Pick image from camera
  Future<void> pickFromCamera() async {
    final File? image = await ImagePickerService.pickImageFromCamera();
    if (image != null) {
      selectedImage.value = image;
    }
  }

  // Show image picker dialog
  void showImagePicker() {
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
                pickFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                pickFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Upload image
  Future<void> uploadImage() async {
    if (selectedImage.value == null) {
      Get.snackbar(
        'Error',
        'Please select an image first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    if (labelController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please provide a label for the image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    try {
      isUploading.value = true;
      final GalleryViewModel galleryViewModel = Get.find<GalleryViewModel>();
      await galleryViewModel.uploadImage(selectedImage.value!, labelController.text);
      
      // Clear the form after successful upload
      selectedImage.value = null;
      labelController.clear();
      
      // Show success snackbar
      Get.snackbar(
        'Success',
        'Image uploaded successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        icon: const Icon(Icons.check_circle, color: Colors.green),
      );
    } catch (e) {
      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to upload image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        icon: const Icon(Icons.error, color: Colors.red),
      );
    } finally {
      isUploading.value = false;
    }
  }

  // Clear selected image
  void clearImage() {
    selectedImage.value = null;
    labelController.clear();
  }
}
