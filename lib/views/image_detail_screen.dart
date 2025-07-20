import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../models/gallery_image.dart';
import '../services/firestore_image_service.dart';

class ImageDetailScreen extends StatelessWidget {
  final GalleryImage image;

  const ImageDetailScreen({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        foregroundColor: Colors.white,
        title: Text(
          image.label,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Full-screen image viewer
          Expanded(
            child: _buildPhotoView(),
          ),
          
          // Image information panel
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  
                  // Upload date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Added on ${_formatDate(image.createdAt)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.7),
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Action button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButton(
                        icon: Icons.info_outline,
                        label: 'Info',
                        onTap: () => _showImageInfo(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white.withOpacity(0.9),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showImageInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Image Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Label: ${image.label}'),
            const SizedBox(height: 8),
            Text('Created: ${_formatDate(image.createdAt)}'),
            const SizedBox(height: 8),
            Text('ID: ${image.id}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoView() {
    // Handle demo mode or invalid data
    if (image.imageData == 'demo-base64-data' || 
        image.imageData == 'demo-base64-data-1' || 
        image.imageData == 'demo-base64-data-2' ||
        image.imageData.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              color: Colors.white,
              size: 100,
            ),
            SizedBox(height: 16),
            Text(
              'Demo Image',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    try {
      // Convert base64 to image bytes
      final Uint8List imageBytes = FirestoreImageService.base64ToImageBytes(image.imageData);
      return PhotoView(
        imageProvider: MemoryImage(imageBytes),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 3,
        heroAttributes: PhotoViewHeroAttributes(tag: image.id),
        loadingBuilder: (context, event) => const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'Failed to load image',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Failed to load image',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }
  }
}
