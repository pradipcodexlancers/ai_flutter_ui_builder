import '../../services/api_service.dart';
import '../../services/image_service.dart';
import '../models/ui_analysis_model.dart';

abstract class IGeminiRepository {
  Future<UIAnalysisModel> analyzeAndGenerate({
    required PickedImageData image,
    String? customInstruction,
    String? modelOverride,
  });

  Future<UIAnalysisModel> regenerateCode({
    required String previousCode,
    required String promptFeedback,
    PickedImageData? originalImage,
    String? modelOverride,
  });

  Future<String?> getApiKey();
  Future<void> saveApiKey(String apiKey);
  Future<void> clearApiKey();
  Future<String> getSelectedModel();
  Future<void> setSelectedModel(String model);
}

class GeminiRepository implements IGeminiRepository {
  final ApiService _apiService;

  GeminiRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  @override
  Future<UIAnalysisModel> analyzeAndGenerate({
    required PickedImageData image,
    String? customInstruction,
    String? modelOverride,
  }) {
    return _apiService.analyzeScreenshot(
      image: image,
      customInstruction: customInstruction,
      modelOverride: modelOverride,
    );
  }

  @override
  Future<UIAnalysisModel> regenerateCode({
    required String previousCode,
    required String promptFeedback,
    PickedImageData? originalImage,
    String? modelOverride,
  }) {
    return _apiService.regenerateWithPrompt(
      previousCode: previousCode,
      promptFeedback: promptFeedback,
      originalImage: originalImage,
      modelOverride: modelOverride,
    );
  }

  @override
  Future<String?> getApiKey() => _apiService.getApiKey();

  @override
  Future<void> saveApiKey(String apiKey) => _apiService.saveApiKey(apiKey);

  @override
  Future<void> clearApiKey() => _apiService.clearApiKey();

  @override
  Future<String> getSelectedModel() => _apiService.getSelectedModel();

  @override
  Future<void> setSelectedModel(String model) =>
      _apiService.setSelectedModel(model);
}
