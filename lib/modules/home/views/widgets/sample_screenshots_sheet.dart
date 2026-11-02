import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../controllers/home_controller.dart';

class SampleScreenshotsSheet extends StatelessWidget {
  final HomeController controller;

  const SampleScreenshotsSheet({super.key, required this.controller});

  static void show(BuildContext context, HomeController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SampleScreenshotsSheet(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
          Text(
            'Try with Sample UI Presets',
            style: AppTypography.font(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Test the Gemini AI conversion instantly with these pre-designed mobile screens.',
            style: AppTypography.font(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          _buildSampleOption(
            context: context,
            title: 'Modern E-Commerce Checkout',
            description: 'Item card, discount voucher field, price breakdown, and Pay button.',
            icon: Icons.shopping_bag_outlined,
            color: const Color(0xFF6366F1),
            presetType: 0,
          ),
          const SizedBox(height: 12),
          _buildSampleOption(
            context: context,
            title: 'Fintech / Crypto Portfolio',
            description: 'Balance overview, send/receive action buttons, and recent transactions.',
            icon: Icons.account_balance_wallet_outlined,
            color: const Color(0xFF10B981),
            presetType: 1,
          ),
          const SizedBox(height: 12),
          _buildSampleOption(
            context: context,
            title: 'Social Profile & Stats',
            description: 'Profile avatar, follower count chips, bio, and follow button.',
            icon: Icons.person_pin_outlined,
            color: const Color(0xFFEC4899),
            presetType: 2,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSampleOption({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required int presetType,
  }) {
    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        final bytes = await _renderPresetToPng(presetType);
        final name = presetType == 0
            ? 'ecommerce_checkout.png'
            : presetType == 1
                ? 'fintech_wallet.png'
                : 'profile_stats.png';
        controller.loadSampleImage(name: name, bytes: bytes);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.font(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: AppTypography.font(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  /// Draws a synthetic mobile screen UI directly onto a canvas and encodes to PNG
  Future<dynamic> _renderPresetToPng(int type) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 390, 800));

    // Background
    final bgPaint = Paint()..color = const Color(0xFFF8FAFC);
    canvas.drawRect(const Rect.fromLTWH(0, 0, 390, 800), bgPaint);

    // App Bar
    final barPaint = Paint()
      ..color = type == 0
          ? const Color(0xFF6366F1)
          : type == 1
              ? const Color(0xFF0F172A)
              : const Color(0xFFEC4899);
    canvas.drawRect(const Rect.fromLTWH(0, 0, 390, 90), barPaint);

    final titlePainter = TextPainter(
      text: TextSpan(
        text: type == 0
            ? 'Checkout Order'
            : type == 1
                ? 'Crypto Wallet'
                : 'User Profile',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    titlePainter.layout();
    titlePainter.paint(canvas, const Offset(24, 46));

    // Card 1
    final cardPaint = Paint()..color = Colors.white;
    final rrect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(20, 110, 350, 140),
      const Radius.circular(16),
    );
    canvas.drawRRect(rrect, cardPaint);

    final cardTextPainter = TextPainter(
      text: TextSpan(
        text: type == 0
            ? 'Wireless Noise-Canceling Headphones\n\$299.00  •  Qty: 1\nColor: Space Gray'
            : type == 1
                ? 'Total Portfolio Balance\n\$24,850.50 USD\n+14.2% this month'
                : 'Alex Rivera\nSenior Flutter Engineer\n@alexrivera • 1.2k followers',
        style: const TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 15,
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    cardTextPainter.layout(maxWidth: 310);
    cardTextPainter.paint(canvas, const Offset(36, 130));

    // Card 2 / Input
    final inputPaint = Paint()..color = const Color(0xFFE2E8F0);
    final inputRrect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(20, 270, 350, 56),
      const Radius.circular(12),
    );
    canvas.drawRRect(inputRrect, inputPaint);

    final inputText = TextPainter(
      text: TextSpan(
        text: type == 0
            ? 'Promo code: SAVE20'
            : type == 1
                ? 'Recipient wallet address (0x...)'
                : 'Write a message to Alex...',
        style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
      ),
      textDirection: TextDirection.ltr,
    );
    inputText.layout();
    inputText.paint(canvas, const Offset(36, 288));

    // Summary Card
    final summaryRrect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(20, 350, 350, 180),
      const Radius.circular(16),
    );
    canvas.drawRRect(summaryRrect, cardPaint);

    final summaryText = TextPainter(
      text: TextSpan(
        text: type == 0
            ? 'Subtotal: \$299.00\nDiscount (20%): -\$59.80\nShipping: Free\nTotal: \$239.20'
            : type == 1
                ? 'Recent Activity:\n• Received 0.45 ETH from Bob\n• Sent \$150 USDC to Alice\n• Staking reward: +0.02 ETH'
                : 'Activity Highlights:\n• 15 Open Source Repositories\n• 482 Contributions this year\n• Top languages: Dart, Kotlin, Swift',
        style: const TextStyle(
          color: Color(0xFF334155),
          fontSize: 14,
          height: 1.8,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    summaryText.layout(maxWidth: 310);
    summaryText.paint(canvas, const Offset(36, 370));

    // Primary CTA Button
    final btnPaint = Paint()
      ..color = type == 0
          ? const Color(0xFF6366F1)
          : type == 1
              ? const Color(0xFF10B981)
              : const Color(0xFFEC4899);
    final btnRrect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(20, 710, 350, 56),
      const Radius.circular(14),
    );
    canvas.drawRRect(btnRrect, btnPaint);

    final btnText = TextPainter(
      text: TextSpan(
        text: type == 0
            ? 'Confirm & Pay \$239.20'
            : type == 1
                ? 'Send Funds'
                : 'Follow Alex',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    btnText.layout();
    btnText.paint(
      canvas,
      Offset(195 - btnText.width / 2, 738 - btnText.height / 2),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(390, 800);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
