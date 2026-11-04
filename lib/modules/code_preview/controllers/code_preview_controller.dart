import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/ui_analysis_model.dart';
import '../../../data/repositories/gemini_repository.dart';
import '../../../services/image_service.dart';

class CodePreviewController extends GetxController {
  final IGeminiRepository _repository;

  CodePreviewController({IGeminiRepository? repository})
      : _repository = repository ?? Get.find<IGeminiRepository>();

  late final Rx<UIAnalysisModel> analysis;
  final RxString currentCode = ''.obs;
  final Rx<Uint8List?> imageBytes = Rx<Uint8List?>(null);
  final Rx<PickedImageData?> originalImage = Rx<PickedImageData?>(null);

  final RxBool isRegenerating = false.obs;
  final RxString regenerationPrompt = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      final model = args['analysis'] as UIAnalysisModel;
      analysis = model.obs;
      currentCode.value = model.flutterCode;
      imageBytes.value = args['imageBytes'] as Uint8List?;
      originalImage.value = args['image'] as PickedImageData?;
    } else {
      final dummy = UIAnalysisModel(
        summary: 'Demo Screen',
        detectedColors: [],
        typography: [],
        detectedComponents: [],
        layoutHierarchy: 'Scaffold',
        responsiveNotes: '',
        flutterCode: '''
import 'package:flutter/material.dart';

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated UI'),
      ),
      body: const Center(
        child: Text('Upload a screenshot to generate code'),
      ),
    );
  }
}
''',
        uiSpec: null,
      );
      analysis = dummy.obs;
      currentCode.value = dummy.flutterCode;
    }
  }

  void copyCodeToClipboard() {
    Clipboard.setData(ClipboardData(text: currentCode.value));
    Get.snackbar(
      'Code Copied!',
      'Flutter Dart code copied to clipboard.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
    );
  }

  Future<void> regenerateCodeWithPrompt(String feedback) async {
    if (feedback.trim().isEmpty) return;

    isRegenerating.value = true;
    try {
      final updatedAnalysis = await _repository.regenerateCode(
        previousCode: currentCode.value,
        promptFeedback: feedback.trim(),
        originalImage: originalImage.value,
      );

      analysis.value = updatedAnalysis;
      currentCode.value = updatedAnalysis.flutterCode;

      Get.snackbar(
        'Regeneration Complete',
        'Flutter code has been successfully updated.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      );
    } catch (e, stack) {
      debugPrint('❌ [REGENERATION ERROR] $e');
      debugPrint('❌ Stack trace:\n$stack');
      Get.snackbar(
        'Regeneration Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        duration: const Duration(seconds: 8),
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isRegenerating.value = false;
    }
  }

  void goToUiPreview() {
    Get.toNamed(
      AppRoutes.uiPreview,
      arguments: {
        'analysis': analysis.value,
        'imageBytes': imageBytes.value,
        'image': originalImage.value,
      },
    );
  }

  void goToAnalysisSpecs() {
    Get.back();
  }
}
