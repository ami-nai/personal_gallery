import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/add_image_viewmodel.dart';

class AddImageScreen extends StatelessWidget {
  const AddImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AddImageViewModel viewModel = Get.put(AddImageViewModel());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Image'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside of text fields
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image selection section
                Obx(() {
                  return Card(
                    elevation: 4,
                    child: InkWell(
                      onTap: viewModel.showImagePicker,
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: viewModel.selectedImage.value != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  viewModel.selectedImage.value!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate,
                                    size: 64,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Tap to select an image',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'From gallery or camera',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  );
                }),
          
                const SizedBox(height: 24),
          
                // Label input section
                TextField(
                  controller: viewModel.labelController,
                  decoration: InputDecoration(
                    labelText: 'Image Label',
                    hintText: 'Enter a description for your image',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.label),
                  ),
                  maxLength: 100,
                  textCapitalization: TextCapitalization.sentences,
                ),
          
                const SizedBox(height: 24),
          
                // Action buttons
                Obx(() {
                  return Row(
                    children: [
                      // Clear button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: viewModel.selectedImage.value != null
                              ? viewModel.clearImage
                              : null,
                          icon: const Icon(Icons.clear),
                          label: const Text('Clear'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Upload button
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: viewModel.isUploading.value
                              ? null
                              : viewModel.uploadImage,
                          icon: viewModel.isUploading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.cloud_upload),
                          label: Text(
                            viewModel.isUploading.value ? 'Uploading...' : 'Upload',
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          
                const SizedBox(height: 16),
          
                // Info text
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Images are stored securely in the cloud and will be available across all your devices.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
