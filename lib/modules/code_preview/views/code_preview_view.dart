import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../controllers/code_preview_controller.dart';
import 'widgets/regeneration_bottom_sheet.dart';

class CodePreviewView extends GetView<CodePreviewController> {
  const CodePreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Dart Code', style: AppTypography.font(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            tooltip: 'Live UI Preview & Compare',
            icon: const Icon(Icons.phone_android, color: AppColors.secondary),
            onPressed: controller.goToUiPreview,
          ),
          IconButton(
            tooltip: 'Copy Code',
            icon: const Icon(Icons.copy_rounded, color: AppColors.primaryLight),
            onPressed: controller.copyCodeToClipboard,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isRegenerating.value) {
          return _buildRegeneratingOverlay();
        }

        return Column(
          children: [
            // Code stats bar
            _buildStatsBar(),

            // Code viewer
            Expanded(
              child: _buildCodeViewer(),
            ),
          ],
        );
      }),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  Widget _buildStatsBar() {
    final code = controller.currentCode.value;
    final lines = code.split('\n').length;
    final chars = code.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceBorder.withOpacity(0.5)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Dart / Flutter 3.x',
                  style: AppTypography.font(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$lines lines  •  $chars chars',
                style: AppTypography.font(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          InkWell(
            onTap: controller.copyCodeToClipboard,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.copy, size: 14, color: AppColors.secondary),
                  const SizedBox(width: 6),
                  Text(
                    'Copy Code',
                    style: AppTypography.font(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeViewer() {
    return Container(
      color: const Color(0xFF282C34), // Atom One Dark editor background
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: HighlightView(
            controller.currentCode.value,
            language: 'dart',
            theme: atomOneDarkTheme,
            padding: EdgeInsets.zero,
            textStyle: AppTypography.mono(
              fontSize: 13.0,
              height: 1.45,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegeneratingOverlay() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Regenerating Flutter Code...',
              style: AppTypography.font(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Gemini is updating widgets according to your instructions.',
              textAlign: TextAlign.center,
              style: AppTypography.font(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
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
                icon: const Icon(Icons.tune_rounded, size: 18),
                label: Text('Regenerate with Prompt', style: AppTypography.font(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: controller.goToUiPreview,
                icon: const Icon(Icons.compare_arrows_rounded, size: 18),
                label: Text('Live UI Preview', style: AppTypography.font(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
