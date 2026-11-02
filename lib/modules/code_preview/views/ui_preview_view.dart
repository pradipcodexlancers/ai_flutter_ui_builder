import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../controllers/code_preview_controller.dart';
import 'widgets/regeneration_bottom_sheet.dart';
import 'widgets/ui_comparison_widget.dart';

class UiPreviewView extends GetView<CodePreviewController> {
  const UiPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live UI Preview & Comparison', style: AppTypography.font(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            tooltip: 'View Flutter Code',
            icon: const Icon(Icons.code_rounded, color: AppColors.primaryLight),
            onPressed: () => Get.back(),
          ),
          IconButton(
            tooltip: 'Regenerate UI',
            icon: const Icon(Icons.tune_rounded, color: AppColors.secondary),
            onPressed: () => RegenerationBottomSheet.show(context, controller),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isRegenerating.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
                ),
                const SizedBox(height: 20),
                Text(
                  'Updating UI Preview with new prompt...',
                  style: AppTypography.font(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          );
        }

        return UiComparisonWidget(
          originalImageBytes: controller.imageBytes.value,
          uiSpec: controller.analysis.value.uiSpec,
          screenSummary: controller.analysis.value.summary,
        );
      }),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.surfaceBorder.withOpacity(0.5))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => RegenerationBottomSheet.show(context, controller),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text('Regenerate UI', style: AppTypography.font(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: controller.copyCodeToClipboard,
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: Text('Copy Flutter Code', style: AppTypography.font(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
