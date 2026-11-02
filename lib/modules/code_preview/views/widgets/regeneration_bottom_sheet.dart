import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../controllers/code_preview_controller.dart';

class RegenerationBottomSheet extends StatefulWidget {
  final CodePreviewController controller;

  const RegenerationBottomSheet({super.key, required this.controller});

  static void show(BuildContext context, CodePreviewController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: RegenerationBottomSheet(controller: controller),
      ),
    );
  }

  @override
  State<RegenerationBottomSheet> createState() =>
      _RegenerationBottomSheetState();
}

class _RegenerationBottomSheetState extends State<RegenerationBottomSheet> {
  final TextEditingController _promptController = TextEditingController();

  final List<String> _suggestions = [
    'Change theme to Dark Mode',
    'Add form validation to TextFields',
    'Make buttons full-width and rounded',
    'Use Material 3 Card elevations',
    'Make UI responsive for tablets',
  ];

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.auto_awesome, color: AppColors.primaryLight, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Regenerate with Additional Prompts',
                style: AppTypography.font(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Ask Gemini to modify colors, refine responsive layout, or add interactive state logic.',
            style: AppTypography.font(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          // Quick Suggestion Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _suggestions.map((suggestion) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(suggestion, style: AppTypography.font(fontSize: 12)),
                    backgroundColor: AppColors.surfaceLight.withOpacity(0.5),
                    side: const BorderSide(color: AppColors.surfaceBorder),
                    onPressed: () {
                      setState(() {
                        _promptController.text = suggestion;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Prompt TextField
          TextField(
            controller: _promptController,
            maxLines: 3,
            autofocus: true,
            style: AppTypography.font(fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'e.g., Change primary color to deep purple, convert into a StatefulWidget with form validation, make buttons 56px height...',
              hintStyle: AppTypography.font(color: AppColors.textMuted, fontSize: 13),
            ),
          ),
          const SizedBox(height: 20),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                final prompt = _promptController.text.trim();
                if (prompt.isNotEmpty) {
                  Navigator.pop(context);
                  widget.controller.regenerateCodeWithPrompt(prompt);
                }
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text('Apply Changes & Regenerate Code', style: AppTypography.font(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
