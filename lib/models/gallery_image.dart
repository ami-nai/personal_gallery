class GalleryImage {
  final String id;
  final String label;
  final String imageData; // Base64 encoded image data instead of URL
  final DateTime createdAt;

  GalleryImage({
    required this.id,
    required this.label,
    required this.imageData,
    required this.createdAt,
  });

  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    return GalleryImage(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      imageData: json['imageData'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'imageData': imageData,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'GalleryImage(id: $id, label: $label, createdAt: $createdAt)';
  }
}
