import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/utils/app_constants.dart';
import '../core/utils/prompt_templates.dart';
import '../data/models/ui_analysis_model.dart';
import 'image_service.dart';

class ApiServiceException implements Exception {
  final String message;
  final int? statusCode;
  final bool isApiKeyError;

  ApiServiceException(
    this.message, {
    this.statusCode,
    this.isApiKeyError = false,
  });

  @override
  String toString() => message;
}

class ApiService {
  final http.Client _client = http.Client();

  /// Retrieve API key: checks SharedPreferences first, then .env
  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final storedKey = prefs.getString(AppConstants.keyGeminiApiKey);
    if (storedKey != null && storedKey.trim().isNotEmpty) {
      return storedKey.trim();
    }

    final envKey = dotenv.env['GEMINI_API_KEY'];
    if (envKey != null && envKey.trim().isNotEmpty) {
      return envKey.trim();
    }

    return null;
  }

  /// Store API key in persistent local preferences
  Future<void> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyGeminiApiKey, apiKey.trim());
  }

  /// Clear stored API key
  Future<void> clearApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyGeminiApiKey);
  }

  /// Get currently selected model
  Future<String> getSelectedModel() async {
    final prefs = await SharedPreferences.getInstance();
    final model = prefs.getString(AppConstants.keySelectedModel);
    if (model == null ||
        model.contains('1.5') ||
        model.contains('2.0') ||
        model.contains('2.5')) {
      await prefs.setString(AppConstants.keySelectedModel, AppConstants.defaultGeminiModel);
      return AppConstants.defaultGeminiModel; // 'gemini-3.5-flash'
    }
    return model;
  }

  /// Save preferred model
  Future<void> setSelectedModel(String model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keySelectedModel, model);
  }

  /// Call Gemini API with an uploaded screenshot
  Future<UIAnalysisModel> analyzeScreenshot({
    required PickedImageData image,
    String? customInstruction,
    String? modelOverride,
  }) async {
    final apiKey = await getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw ApiServiceException(
        'Gemini API Key is missing. Please set it in Settings or your .env file.',
        isApiKeyError: true,
      );
    }

    final model = modelOverride ?? await getSelectedModel();
    final prompt = PromptTemplates.analyzeAndGenerateFlutterPrompt(
      customInstruction: customInstruction,
    );

    final requestBody = {
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': prompt},
            {
              'inlineData': {
                'mimeType': image.mimeType,
                'data': image.base64String,
              }
            }
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.2,
        'responseMimeType': 'application/json',
      }
    };

    return _executeGeminiRequest(
      model: model,
      apiKey: apiKey,
      requestBody: requestBody,
    );
  }

  /// Regenerate code using existing code + new prompt instructions
  Future<UIAnalysisModel> regenerateWithPrompt({
    required String previousCode,
    required String promptFeedback,
    PickedImageData? originalImage,
    String? modelOverride,
  }) async {
    final apiKey = await getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw ApiServiceException(
        'Gemini API Key is missing. Please set it in Settings or your .env file.',
        isApiKeyError: true,
      );
    }

    final model = modelOverride ?? await getSelectedModel();
    final prompt = PromptTemplates.regenerateWithFeedbackPrompt(
      previousCode: previousCode,
      feedback: promptFeedback,
    );

    final List<Map<String, dynamic>> parts = [
      {'text': prompt},
    ];

    if (originalImage != null) {
      parts.add({
        'inlineData': {
          'mimeType': originalImage.mimeType,
          'data': originalImage.base64String,
        }
      });
    }

    final requestBody = {
      'contents': [
        {
          'role': 'user',
          'parts': parts,
        }
      ],
      'generationConfig': {
        'temperature': 0.2,
        'responseMimeType': 'application/json',
      }
    };

    return _executeGeminiRequest(
      model: model,
      apiKey: apiKey,
      requestBody: requestBody,
    );
  }

  /// Internal request execution with robust parsing and error translation
  Future<UIAnalysisModel> _executeGeminiRequest({
    required String model,
    required String apiKey,
    required Map<String, dynamic> requestBody,
  }) async {
    final uri = Uri.parse(
      '${AppConstants.geminiBaseUrl}/$model:generateContent?key=$apiKey',
    );

    debugPrint('🚀 [GEMINI REQUEST] Calling model: $model');
    debugPrint('🚀 [GEMINI REQUEST] URI: ${uri.replace(queryParameters: {'key': '***'})}');

    http.Response response;
    try {
      response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 90));
    } on TimeoutException {
      debugPrint('❌ [GEMINI TIMEOUT] Request timed out after 90 seconds.');
      throw ApiServiceException(
        'Connection to Gemini API timed out after 90 seconds. Please check your internet connection and try again.',
      );
    } catch (e) {
      debugPrint('❌ [GEMINI NETWORK ERROR] $e');
      throw ApiServiceException('Network error connecting to Gemini API: $e');
    }

    debugPrint('📥 [GEMINI RESPONSE] Status Code: ${response.statusCode}');

    // If model is not found, deprecated or unsupported, automatically fallback to active models
    if (response.statusCode == 404 ||
        response.body.contains('not found') ||
        response.body.contains('no longer available') ||
        response.body.contains('not supported')) {
      if (model != 'gemini-3.5-flash') {
        debugPrint('⚠️ [GEMINI AUTO-FALLBACK] Model "$model" unavailable. Retrying with "gemini-3.5-flash"...');
        return _executeGeminiRequest(
          model: 'gemini-3.5-flash',
          apiKey: apiKey,
          requestBody: requestBody,
        );
      } else if (model != 'gemini-flash-lite-latest') {
        debugPrint('⚠️ [GEMINI AUTO-FALLBACK] Retrying with "gemini-flash-lite-latest"...');
        return _executeGeminiRequest(
          model: 'gemini-flash-lite-latest',
          apiKey: apiKey,
          requestBody: requestBody,
        );
      }
    }

    // If high demand spike (503), retry with flash-lite-latest
    if (response.statusCode == 503 && model != 'gemini-flash-lite-latest') {
      debugPrint('⚠️ [GEMINI SPIKE 503] Model "$model" busy. Retrying with "gemini-flash-lite-latest"...');
      return _executeGeminiRequest(
        model: 'gemini-flash-lite-latest',
        apiKey: apiKey,
        requestBody: requestBody,
      );
    }

    if (response.statusCode != 200) {
      _handleHttpErrors(response, model);
    }

    return _parseGeminiResponse(response.body);
  }

  void _handleHttpErrors(http.Response response, String model) {
    debugPrint('❌ ══════════════ GEMINI API ERROR DETAILS ══════════════');
    debugPrint('❌ Model: $model');
    debugPrint('❌ Status Code: ${response.statusCode}');
    debugPrint('❌ Response Body: ${response.body}');
    debugPrint('❌ ═══════════════════════════════════════════════════════');

    try {
      final errorJson = jsonDecode(response.body);
      final errorObj = errorJson['error'];
      final message = errorObj != null
          ? (errorObj['message'] ?? response.body)
          : response.body;

      if (response.statusCode == 400 &&
          message.toString().toLowerCase().contains('api key')) {
        throw ApiServiceException(
          'Invalid Gemini API key provided. Please verify your key at https://aistudio.google.com/app/apikey',
          statusCode: 400,
          isApiKeyError: true,
        );
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        throw ApiServiceException(
          'Unauthorized: Check your Gemini API Key or permissions. ($message)',
          statusCode: response.statusCode,
          isApiKeyError: true,
        );
      } else if (response.statusCode == 429) {
        throw ApiServiceException(
          'Gemini Free Tier Quota Exceeded (HTTP 429). Please wait a moment or try another model.',
          statusCode: 429,
        );
      } else {
        throw ApiServiceException(
          'Gemini API error (${response.statusCode}): $message',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiServiceException) rethrow;
      throw ApiServiceException(
        'Gemini API request failed with status ${response.statusCode}: ${response.body}',
        statusCode: response.statusCode,
      );
    }
  }

  UIAnalysisModel _parseGeminiResponse(String responseBody) {
    try {
      final rootJson = jsonDecode(responseBody) as Map<String, dynamic>;
      final candidates = rootJson['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        throw ApiServiceException('Gemini returned an empty response candidate.');
      }

      final content = candidates.first['content'] as Map<String, dynamic>?;
      final parts = content?['parts'] as List?;
      if (parts == null || parts.isEmpty) {
        throw ApiServiceException('Gemini response contains no text parts.');
      }

      final rawText = parts.first['text']?.toString() ?? '';
      return _extractJsonAndBuildModel(rawText);
    } catch (e) {
      if (e is ApiServiceException) rethrow;
      throw ApiServiceException('Failed to process Gemini response: $e');
    }
  }

  UIAnalysisModel _extractJsonAndBuildModel(String rawText) {
    String cleaned = rawText.trim();

    // Strip markdown code fences if present (e.g. ```json ... ```)
    if (cleaned.startsWith('```json')) {
      cleaned = cleaned.substring(7);
    } else if (cleaned.startsWith('```')) {
      cleaned = cleaned.substring(3);
    }
    if (cleaned.endsWith('```')) {
      cleaned = cleaned.substring(0, cleaned.length - 3);
    }
    cleaned = cleaned.trim();

    // Find first '{' and last '}'
    final startIndex = cleaned.indexOf('{');
    final endIndex = cleaned.lastIndexOf('}');

    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      final jsonSubstring = cleaned.substring(startIndex, endIndex + 1);
      try {
        final decoded = jsonDecode(jsonSubstring) as Map<String, dynamic>;
        return UIAnalysisModel.fromJson(decoded);
      } catch (jsonErr) {
        // Fallback: extract dart code if pure JSON decoding fails
        return _buildFallbackModel(cleaned);
      }
    }

    return _buildFallbackModel(cleaned);
  }

  UIAnalysisModel _buildFallbackModel(String rawText) {
    // If the response wasn't clean JSON, extract any Dart code block
    final dartRegex = RegExp(r'```(?:dart)?\s*([\s\S]*?)```');
    final match = dartRegex.firstMatch(rawText);
    final extractedCode = match != null ? match.group(1)! : rawText;

    return UIAnalysisModel(
      summary: 'Generated Flutter Screen',
      detectedColors: [],
      typography: [],
      detectedComponents: [],
      layoutHierarchy: 'Custom Scaffold',
      responsiveNotes: 'Responsive layout generated based on visual screenshot.',
      flutterCode: extractedCode,
      uiSpec: null,
    );
  }
}

