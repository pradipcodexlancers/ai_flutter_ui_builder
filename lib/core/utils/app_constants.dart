class AppConstants {
  AppConstants._();

  static const String appName = 'Flutter UI Architect AI';
  static const String appTagline = 'Convert UI Screenshots into Production Flutter Code';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String keyGeminiApiKey = 'gemini_api_key';
  static const String keySelectedModel = 'gemini_selected_model';

  // Gemini Models
  // Google AI Studio supports gemini-2.5-flash, gemini-1.5-flash, etc.
  static const String defaultGeminiModel = 'gemini-2.5-flash';
  static const List<String> availableModels = [
    'gemini-2.5-flash',
    'gemini-1.5-flash',
  ];

  // API endpoints
  static const String geminiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  // Validation Limits
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const List<String> supportedImageExtensions = [
    'png',
    'jpg',
    'jpeg',
    'webp',
  ];

  // External Links
  static const String geminiStudioApiKeyUrl =
      'https://aistudio.google.com/app/apikey';
  static const String flutterDocsUrl = 'https://docs.flutter.dev/';
}
