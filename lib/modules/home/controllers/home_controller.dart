import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_constants.dart';
import '../../../data/models/ui_analysis_model.dart';
import '../../../data/repositories/gemini_repository.dart';
import '../../../services/image_service.dart';

class HomeController extends GetxController {
  final IGeminiRepository _repository;
  final ImageService _imageService;

  HomeController({
    IGeminiRepository? repository,
    ImageService? imageService,
  })  : _repository = repository ?? GeminiRepository(),
        _imageService = imageService ?? ImageService();

  final Rx<PickedImageData?> selectedImage = Rx<PickedImageData?>(null);
  final RxString customPrompt = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString loadingStatusText = 'Preparing analysis...'.obs;
  final RxString apiKey = ''.obs;
  final RxBool isApiKeyConfigured = false.obs;
  final RxString selectedModel = AppConstants.defaultGeminiModel.obs;

  @override
  void onInit() {
    super.onInit();
    checkApiKeyStatus();
  }

  Future<void> checkApiKeyStatus() async {
    final key = await _repository.getApiKey();
    if (key != null && key.isNotEmpty) {
      apiKey.value = key;
      isApiKeyConfigured.value = true;
    } else {
      apiKey.value = '';
      isApiKeyConfigured.value = false;
    }
    selectedModel.value = await _repository.getSelectedModel();
  }

  Future<void> saveApiKey(String newKey) async {
    await _repository.saveApiKey(newKey);
    await checkApiKeyStatus();
    Get.snackbar(
      'API Key Saved',
      'Gemini API key has been stored successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> pickImageFromGallery() async {
    try {
      final img = await _imageService.pickImageFromGallery();
      if (img != null) {
        selectedImage.value = img;
      }
    } catch (e) {
      _showErrorSnackbar('Image Pick Error', e.toString());
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final img = await _imageService.pickImageFromCamera();
      if (img != null) {
        selectedImage.value = img;
      }
    } catch (e) {
      _showErrorSnackbar('Camera Error', e.toString());
    }
  }

  void clearSelectedImage() {
    selectedImage.value = null;
    customPrompt.value = '';
  }

  /// Preset sample screenshot for testing without external files
  void loadSampleImage({
    required String name,
    required Uint8List bytes,
  }) {
    selectedImage.value = PickedImageData(
      name: name,
      path: 'sample://$name',
      bytes: bytes,
      mimeType: 'image/png',
      sizeInBytes: bytes.length,
    );
  }

  Future<void> startAnalysisAndGeneration() async {
    if (selectedImage.value == null) {
      _showErrorSnackbar('No Image', 'Please select or upload a UI screenshot first.');
      return;
    }

    if (!isApiKeyConfigured.value) {
      _showApiKeyRequiredDialog();
      return;
    }

    isLoading.value = true;
    loadingStatusText.value = 'Connecting to Google Gemini API...';

    try {
      // Step 1: Status update
      await Future.delayed(const Duration(milliseconds: 300));
      loadingStatusText.value = 'Analyzing colors, fonts, spacing and components...';

      // Step 2: Call Gemini API
      final UIAnalysisModel analysis = await _repository.analyzeAndGenerate(
        image: selectedImage.value!,
        customInstruction: customPrompt.value.trim().isEmpty ? null : customPrompt.value.trim(),
        modelOverride: selectedModel.value,
      );

      loadingStatusText.value = 'Finalizing clean Flutter Dart code...';
      await Future.delayed(const Duration(milliseconds: 300));

      // Navigate to Analysis and Code Preview Screen
      Get.toNamed(
        AppRoutes.analysis,
        arguments: {
          'analysis': analysis,
          'imageBytes': selectedImage.value!.bytes,
          'imageName': selectedImage.value!.name,
          'image': selectedImage.value,
        },
      );
    } catch (e) {
      _showErrorSnackbar('Analysis Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFEF4444),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 5),
    );
  }

  void _showApiKeyRequiredDialog() {
    Get.defaultDialog(
      title: 'Gemini API Key Required',
      middleText:
          'Please enter your Google Gemini API key to convert screenshots into Flutter code.',
      textConfirm: 'Configure Key',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        // The view can show the API key sheet
      },
    );
  }
}
