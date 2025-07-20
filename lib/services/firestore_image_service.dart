import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/gallery_image.dart';

class FirestoreImageService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'gallery_images';

  // Convert image file to base64 string
  static Future<String> _imageToBase64(File imageFile) async {
    try {
      Uint8List imageBytes = await imageFile.readAsBytes();
      return base64Encode(imageBytes);
    } catch (e) {
      throw Exception('Failed to convert image to base64: $e');
    }
  }

  // Resize image to reduce size (optional - basic implementation)
  static Future<File> _resizeImage(File imageFile) async {
    // image compression
    // For now, just return the original file
    return imageFile;
  }

  // Upload image (convert to base64 and store in Firestore)
  static Future<GalleryImage> uploadImage(File imageFile, String label) async {
    try {
      // Resize image if needed (to stay within Firestore limits)
      final File resizedImage = await _resizeImage(imageFile);
      
      // Convert to base64
      final String base64Image = await _imageToBase64(resizedImage);
      
      // Check size (Firestore has a 1MB limit per document)
      if (base64Image.length > 800000) { // ~800KB limit to be safe
        throw Exception('Image too large. Please select a smaller image.');
      }

      // Create image object
      final String imageId = const Uuid().v4();
      final GalleryImage newImage = GalleryImage(
        id: imageId,
        label: label.trim(),
        imageData: base64Image,
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestore
          .collection(_collectionName)
          .doc(imageId)
          .set(newImage.toJson());

      return newImage;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Get all images from Firestore
  static Future<List<GalleryImage>> getAllImages() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => GalleryImage.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch images: $e');
    }
  }

  // Delete image from Firestore
  static Future<void> deleteImage(String imageId) async {
    try {
      await _firestore.collection(_collectionName).doc(imageId).delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  // Stream of images for real-time updates
  static Stream<List<GalleryImage>> getImagesStream() {
    return _firestore
        .collection(_collectionName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GalleryImage.fromJson(doc.data()))
            .toList());
  }

  // Convert base64 string back to image bytes for display
  static Uint8List base64ToImageBytes(String base64String) {
    try {
      return base64Decode(base64String);
    } catch (e) {
      throw Exception('Failed to decode base64 image: $e');
    }
  }
}
