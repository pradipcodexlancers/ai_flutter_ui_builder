import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/ui_analysis_model.dart';
import '../../../services/image_service.dart';

class AnalysisController extends GetxController {
  late final Rx<UIAnalysisModel> analysis;
  final Rx<Uint8List?> imageBytes = Rx<Uint8List?>(null);
  final RxString imageName = ''.obs;
  final Rx<PickedImageData?> pickedImage = Rx<PickedImageData?>(null);

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      final model = args['analysis'] as UIAnalysisModel;
      analysis = model.obs;
      imageBytes.value = args['imageBytes'] as Uint8List?;
      imageName.value = (args['imageName'] as String?) ?? 'screenshot.png';
      pickedImage.value = args['image'] as PickedImageData?;
    } else {
      analysis = UIAnalysisModel(
        summary: 'No analysis data found.',
        detectedColors: [],
        typography: [],
        detectedComponents: [],
        layoutHierarchy: 'Scaffold',
        responsiveNotes: 'None',
        flutterCode: '// No code generated',
        uiSpec: null,
      ).obs;
    }
  }

  void copyColorToClipboard(String hex, String name) {
    Clipboard.setData(ClipboardData(text: hex));
    Get.snackbar(
      'Copied $name',
      '$hex copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E293B),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
    );
  }

  void goToCodePreview() {
    Get.toNamed(
      AppRoutes.codePreview,
      arguments: {
        'analysis': analysis.value,
        'imageBytes': imageBytes.value,
        'image': pickedImage.value,
      },
    );
  }

  void goToUiPreview() {
    Get.toNamed(
      AppRoutes.uiPreview,
      arguments: {
        'analysis': analysis.value,
        'imageBytes': imageBytes.value,
        'image': pickedImage.value,
      },
    );
  }
}
