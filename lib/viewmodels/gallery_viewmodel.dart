import 'dart:io';
import 'package:get/get.dart';
import '../models/gallery_image.dart';
import '../services/firestore_image_service.dart';

class GalleryViewModel extends GetxController {
  final RxList<GalleryImage> images = <GalleryImage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadImages();
  }

  // Load all images from Firestore
  Future<void> loadImages() async {
    try {
      isLoading.value = true;
      final List<GalleryImage> fetchedImages = await FirestoreImageService.getAllImages();
      images.assignAll(fetchedImages);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load images: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Upload new image with label
  Future<void> uploadImage(File imageFile, String label) async {
    if (label.trim().isEmpty) {
      throw Exception('Please provide a label for the image');
    }

    try {
      isUploading.value = true;

      // Upload image to Firestore (as base64)
      final GalleryImage newImage = await FirestoreImageService.uploadImage(
        imageFile, 
        label.trim()
      );

      // Add to local list
      images.insert(0, newImage);

    } catch (e) {
      // Re-throw the error to be handled by the calling method
      rethrow;
    } finally {
      isUploading.value = false;
    }
  }

  // Delete image
  Future<void> deleteImage(GalleryImage image) async {
    try {
      await FirestoreImageService.deleteImage(image.id);
      images.remove(image);
      Get.snackbar(
        'Success',
        'Image deleted successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Refresh images
  Future<void> refreshImages() async {
    await loadImages();
  }
}
