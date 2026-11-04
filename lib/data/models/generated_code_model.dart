class GeneratedCodeModel {
  final String code;
  final String? versionNote;
  final DateTime generatedAt;
  final String modelName;

  GeneratedCodeModel({
    required this.code,
    this.versionNote,
    DateTime? generatedAt,
    this.modelName = 'gemini-3.5-flash',
  }) : generatedAt = generatedAt ?? DateTime.now();

  int get lineCount => code.split('\n').length;
  int get characterCount => code.length;
}
