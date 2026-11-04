import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../controllers/home_controller.dart';
import 'widgets/api_key_dialog.dart';
import 'widgets/image_upload_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState();
        }

        return _buildMainContent(context);
      }),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value || controller.selectedImage.value == null) {
          return const SizedBox.shrink();
        }
        return _buildBottomBar(context);
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.flutter_dash, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'UI Architect AI',
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.font(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  'Gemini-Powered Flutter Builder',
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.font(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Obx(() {
          final isConfigured = controller.isApiKeyConfigured.value;
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ActionChip(
              avatar: Icon(
                isConfigured ? Icons.check_circle : Icons.warning_amber_rounded,
                size: 16,
                color: isConfigured ? AppColors.success : AppColors.warning,
              ),
              label: Text(
                isConfigured ? 'Gemini Ready' : 'Set API Key',
                style: AppTypography.font(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isConfigured ? AppColors.success : AppColors.warning,
                ),
              ),
              backgroundColor: isConfigured
                  ? AppColors.success.withOpacity(0.12)
                  : AppColors.warning.withOpacity(0.12),
              side: BorderSide(
                color: isConfigured
                    ? AppColors.success.withOpacity(0.3)
                    : AppColors.warning.withOpacity(0.3),
              ),
              onPressed: () => ApiKeyDialog.show(context, controller),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Banner
              _buildHeroBanner(context),
              const SizedBox(height: 20),

              // Upload / Preview Card
              ImageUploadCard(controller: controller),
              const SizedBox(height: 24),

              // Feature Highlights Grid
              _buildFeaturePills(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceBorder.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryLight.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome, size: 14, color: AppColors.primaryLight),
                    const SizedBox(width: 6),
                    Text(
                      'Gemini 3.5 Flash Vision',
                      style: AppTypography.font(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Turn Any Screenshot into\nProduction Flutter Code',
            style: AppTypography.font(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload a screenshot of any mobile or web app screen. Antigravity AI inspects typography, component trees, spacing, and generates production-ready Dart widgets with side-by-side preview.',
            style: AppTypography.font(fontSize: 13, color: AppColors.textSecondary, height: 1.45),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturePills() {
    final features = [
      {'icon': Icons.palette_outlined, 'title': 'Color Palette Extraction', 'desc': 'Extracts exact hex codes and roles'},
      {'icon': Icons.widgets_outlined, 'title': 'Component Detection', 'desc': 'Maps app bars, buttons, text fields'},
      {'icon': Icons.code_rounded, 'title': 'Flutter Dart Code', 'desc': 'Clean, responsive, reusable widgets'},
      {'icon': Icons.compare_arrows_rounded, 'title': 'UI Comparison Slider', 'desc': 'Compare screenshot with rendered UI'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Engine Capabilities',
          style: AppTypography.font(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: features.map((f) {
            return Container(
              width: 320,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.surfaceBorder.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(f['icon'] as IconData, size: 20, color: AppColors.primaryLight),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f['title'] as String,
                          style: AppTypography.font(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          f['desc'] as String,
                          style: AppTypography.font(fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'AI Engine at Work',
              style: AppTypography.font(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                controller.loadingStatusText.value,
                textAlign: TextAlign.center,
                style: AppTypography.font(
                  fontSize: 14,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Analyzing visual components, building widget trees & formatting Flutter Dart code...',
              textAlign: TextAlign.center,
              style: AppTypography.font(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.surfaceBorder.withOpacity(0.5))),
      ),
      child: SafeArea(
        child: ElevatedButton.icon(
          onPressed: controller.startAnalysisAndGeneration,
          icon: const Icon(Icons.auto_awesome, size: 20),
          label: Text(
            'Analyze UI & Generate Flutter Code',
            style: AppTypography.font(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }
}
