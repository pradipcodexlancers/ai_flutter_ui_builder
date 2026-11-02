import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/ui_analysis_model.dart';

class TypographyCard extends StatelessWidget {
  final List<TypographyItem> typography;

  const TypographyCard({super.key, required this.typography});

  @override
  Widget build(BuildContext context) {
    if (typography.isEmpty) return const SizedBox.shrink();

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
              const Icon(Icons.text_fields_rounded, color: AppColors.secondary, size: 20),
              const SizedBox(width: 10),
              Text(
                'Typography Hierarchy',
                style: AppTypography.font(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: typography.length,
            separatorBuilder: (_, __) => const Divider(height: 16),
            itemBuilder: (context, index) {
              final item = typography[index];
              return Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${item.fontSize.toInt()}',
                      style: AppTypography.mono(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.role,
                          style: AppTypography.font(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Weight: ${item.fontWeight}  •  Color: ${item.colorHex}',
                          style: AppTypography.font(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
