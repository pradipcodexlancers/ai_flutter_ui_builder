import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../controllers/home_controller.dart';
import 'sample_screenshots_sheet.dart';

class ImageUploadCard extends StatelessWidget {
  final HomeController controller;

  const ImageUploadCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final img = controller.selectedImage.value;

    if (img == null) {
      return _buildEmptyPicker(context);
    }

    return _buildSelectedImagePreview(context, img);
  }

  Widget _buildEmptyPicker(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.4),
          width: 1.5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud_upload_outlined,
              size: 44,
              color: AppColors.primaryLight,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Upload UI Screenshot',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select any mobile or web UI design from your gallery.\nGemini AI will analyze colors, layout and generate Flutter code.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: controller.pickImageFromGallery,
                icon: const Icon(Icons.photo_library_outlined, size: 18),
                label: const Text('Choose Photo'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: controller.pickImageFromCamera,
                icon: const Icon(Icons.camera_alt_outlined, size: 18),
                label: const Text('Camera'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => SampleScreenshotsSheet.show(context, controller),
            icon: const Icon(Icons.auto_awesome_outlined, size: 16, color: AppColors.secondary),
            label: const Text(
              'Or try a Sample UI Screen',
              style: TextStyle(color: AppColors.secondary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedImagePreview(BuildContext context, dynamic img) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Selected Screenshot',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                tooltip: 'Remove',
                icon: const Icon(Icons.close, color: AppColors.textMuted, size: 20),
                onPressed: controller.clearSelectedImage,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Thumbnail with details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 100,
                  height: 140,
                  color: Colors.black26,
                  child: Image.memory(
                    img.bytes,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      img.name,
                      maxLines: 2,
                      overflow: TextTransitions.fade,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _buildBadge(img.mimeType.toUpperCase().replaceAll('IMAGE/', '')),
                        _buildBadge('${img.sizeInKb} KB'),
                        _buildBadge('Ready for AI'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: controller.pickImageFromGallery,
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Replace', style: TextStyle(fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Optional Custom Instruction Prompt
          const Text(
            'Additional AI Prompt (Optional)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            onChanged: (val) => controller.customPrompt.value = val,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'e.g., Use dark mode theme, make cards 16px rounded, use emerald green accent color...',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class TextTransitions {
  static const TextOverflow fade = TextOverflow.ellipsis;
}
