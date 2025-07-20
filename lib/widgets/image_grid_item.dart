import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/gallery_image.dart';
import '../views/image_detail_screen.dart';
import '../services/firestore_image_service.dart';

class ImageGridItem extends StatelessWidget {
  final GalleryImage image;
  final VoidCallback? onDelete;

  const ImageGridItem({
    super.key,
    required this.image,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openImageDetail(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _buildImageWidget(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      image.label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red,
                      onPressed: () => _showDeleteConfirmation(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openImageDetail(BuildContext context) {
    Get.to(() => ImageDetailScreen(image: image));
  }

  void _showDeleteConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Image'),
        content: Text('Are you sure you want to delete "${image.label}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              onDelete?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget() {
    // Handle demo mode or invalid data
    if (image.imageData == 'demo-base64-data' || 
        image.imageData == 'demo-base64-data-1' || 
        image.imageData == 'demo-base64-data-2' ||
        image.imageData.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              color: Colors.grey[400],
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(
              'Demo Image',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    try {
      // Convert base64 to image bytes
      final Uint8List imageBytes = FirestoreImageService.base64ToImageBytes(image.imageData);
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          imageBytes,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    } catch (e) {
      // Error handling - show error icon
      return Container(
        color: Colors.grey[200],
        child: const Icon(
          Icons.error_outline,
          color: Colors.grey,
          size: 40,
        ),
      );
    }
  }
}
