import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/gallery_viewmodel.dart';
import '../widgets/image_grid_item.dart';
import '../widgets/common_widgets.dart';
import 'add_image_screen.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GalleryViewModel viewModel = Get.find<GalleryViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Gallery'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () => viewModel.refreshImages(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        if (viewModel.isLoading.value) {
          return const CustomLoadingIndicator(message: 'Loading images...');
        }

        if (viewModel.images.isEmpty) {
          return EmptyState(
            message: 'No images in your gallery yet.\nTap the + button to add your first image!',
            icon: Icons.photo_library_outlined,
            onRetry: () => viewModel.refreshImages(),
          );
        }

        return RefreshIndicator(
          onRefresh: () => viewModel.refreshImages(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.8,
              ),
              itemCount: viewModel.images.length,
              itemBuilder: (context, index) {
                final image = viewModel.images[index];
                return ImageGridItem(
                  image: image,
                  onDelete: () => viewModel.deleteImage(image),
                );
              },
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddImageScreen()),
        tooltip: 'Add Image',
        child: const Icon(Icons.add),
      ),
    );
  }
}
