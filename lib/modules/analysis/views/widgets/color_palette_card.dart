import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/ui_analysis_model.dart';
import '../../controllers/analysis_controller.dart';

class ColorPaletteCard extends StatelessWidget {
  final List<ColorItem> colors;
  final AnalysisController controller;

  const ColorPaletteCard({
    super.key,
    required this.colors,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) {
      return const SizedBox.shrink();
    }

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
              const Icon(Icons.palette_outlined, color: AppColors.primaryLight, size: 20),
              const SizedBox(width: 10),
              Text(
                'Identified Color Palette',
                style: AppTypography.font(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Tap any swatch to copy its hex value for Flutter ThemeData.',
            style: AppTypography.font(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: colors.map((c) => _buildColorChip(c)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildColorChip(ColorItem colorItem) {
    Color parsedColor;
    try {
      String hex = colorItem.hex.replaceAll('#', '').trim();
      if (hex.length == 6) hex = 'FF$hex';
      parsedColor = Color(int.parse(hex, radix: 16));
    } catch (_) {
      parsedColor = AppColors.primary;
    }

    return InkWell(
      onTap: () => controller.copyColorToClipboard(colorItem.hex, colorItem.name),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceBorder.withOpacity(0.7)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: parsedColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24, width: 1),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  colorItem.name,
                  style: AppTypography.font(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  colorItem.hex,
                  style: AppTypography.mono(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 6),
            const Icon(Icons.copy, size: 12, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
