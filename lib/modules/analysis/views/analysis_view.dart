import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../controllers/analysis_controller.dart';
import 'widgets/color_palette_card.dart';
import 'widgets/components_card.dart';
import 'widgets/typography_card.dart';

class AnalysisView extends GetView<AnalysisController> {
  const AnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UI Analysis & Specs', style: AppTypography.font(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            tooltip: 'Live UI Preview',
            icon: const Icon(Icons.phone_android, color: AppColors.secondary),
            onPressed: controller.goToUiPreview,
          ),
          IconButton(
            tooltip: 'Flutter Dart Code',
            icon: const Icon(Icons.code_rounded, color: AppColors.primaryLight),
            onPressed: controller.goToCodePreview,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Screenshot & Summary Header
                _buildHeaderCard(),
                const SizedBox(height: 18),

                // Color Palette
                ColorPaletteCard(
                  colors: controller.analysis.value.detectedColors,
                  controller: controller,
                ),
                const SizedBox(height: 18),

                // Identified Components
                ComponentsCard(
                  components: controller.analysis.value.detectedComponents,
                ),
                const SizedBox(height: 18),

                // Typography
                TypographyCard(
                  typography: controller.analysis.value.typography,
                ),
                const SizedBox(height: 18),

                // Layout & Responsive Architecture Card
                _buildLayoutNotesCard(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder.withOpacity(0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.imageBytes.value != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 70,
                height: 110,
                child: Image.memory(
                  controller.imageBytes.value!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'AI Analysis Complete',
                    style: AppTypography.font(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.analysis.value.summary,
                  style: AppTypography.font(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Structure: ${controller.analysis.value.layoutHierarchy}',
                  style: AppTypography.mono(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayoutNotesCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.architecture_rounded, color: AppColors.warning, size: 20),
              const SizedBox(width: 10),
              Text(
                'Layout & Responsiveness Architecture',
                style: AppTypography.font(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            controller.analysis.value.responsiveNotes,
            style: AppTypography.font(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
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
                onPressed: controller.goToUiPreview,
                icon: const Icon(Icons.compare_arrows_rounded, size: 18),
                label: Text('Live UI Preview', style: AppTypography.font(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: controller.goToCodePreview,
                icon: const Icon(Icons.code_rounded, size: 18),
                label: Text('View Dart Code', style: AppTypography.font(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
