import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_constants.dart';
import '../../controllers/home_controller.dart';

class ApiKeyDialog extends StatefulWidget {
  final HomeController controller;

  const ApiKeyDialog({super.key, required this.controller});

  static void show(BuildContext context, HomeController controller) {
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
        child: ApiKeyDialog(controller: controller),
      ),
    );
  }

  @override
  State<ApiKeyDialog> createState() => _ApiKeyDialogState();
}

class _ApiKeyDialogState extends State<ApiKeyDialog> {
  late final TextEditingController _textController;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.controller.apiKey.value);
  }

  @override
  void dispose() {
    _textController.dispose();
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
          // Drag handle
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
          const SizedBox(height: 18),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.key_rounded, color: AppColors.primaryLight, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Google Gemini API Settings',
                      style: AppTypography.font(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Free tier supported (Google AI Studio)',
                      style: AppTypography.font(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Info banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: AppColors.primaryLight, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You can get a free Gemini API Key from Google AI Studio. You can also define it in your .env file as GEMINI_API_KEY.',
                        style: AppTypography.font(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(
                            const ClipboardData(text: AppConstants.geminiStudioApiKeyUrl),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('AI Studio URL copied to clipboard!', style: AppTypography.font()),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Copy AI Studio Link',
                              style: AppTypography.font(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.copy, size: 13, color: AppColors.secondary),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // API Key Input
          Text(
            'API Key',
            style: AppTypography.font(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _textController,
            obscureText: _obscureText,
            style: AppTypography.mono(fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'AIzaSy...',
              prefixIcon: const Icon(Icons.lock_outline, size: 18, color: AppColors.textMuted),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 18,
                  color: AppColors.textMuted,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Model Selection
          Text(
            'Preferred Model',
            style: AppTypography.font(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: widget.controller.selectedModel.value,
                dropdownColor: AppColors.surface,
                isExpanded: true,
                style: AppTypography.font(color: AppColors.textPrimary, fontSize: 14),
                items: AppConstants.availableModels.map((m) {
                  return DropdownMenuItem(
                    value: m,
                    child: Text(m, style: AppTypography.font()),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      widget.controller.selectedModel.value = val;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              if (widget.controller.isApiKeyConfigured.value) ...[
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                    onPressed: () async {
                      await widget.controller.saveApiKey('');
                      if (mounted) Navigator.pop(context);
                    },
                    child: Text('Clear', style: AppTypography.font()),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () async {
                    final key = _textController.text.trim();
                    if (key.isNotEmpty) {
                      await widget.controller.saveApiKey(key);
                      if (mounted) Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a valid API Key.', style: AppTypography.font())),
                      );
                    }
                  },
                  child: Text('Save API Key', style: AppTypography.font(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
