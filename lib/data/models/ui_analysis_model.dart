class ColorItem {
  final String name;
  final String hex;
  final String usage;

  const ColorItem({
    required this.name,
    required this.hex,
    required this.usage,
  });

  factory ColorItem.fromJson(Map<String, dynamic> json) {
    return ColorItem(
      name: json['name']?.toString() ?? 'Color',
      hex: json['hex']?.toString() ?? '#6366F1',
      usage: json['usage']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'hex': hex,
        'usage': usage,
      };
}

class TypographyItem {
  final String role;
  final double fontSize;
  final String fontWeight;
  final String colorHex;

  const TypographyItem({
    required this.role,
    required this.fontSize,
    required this.fontWeight,
    required this.colorHex,
  });

  factory TypographyItem.fromJson(Map<String, dynamic> json) {
    double parsedSize = 14.0;
    final rawSize = json['font_size'] ?? json['fontSize'] ?? json['size'];
    if (rawSize is num) {
      parsedSize = rawSize.toDouble();
    } else if (rawSize is String) {
      parsedSize = double.tryParse(rawSize) ?? 14.0;
    }

    return TypographyItem(
      role: json['role']?.toString() ?? 'Body',
      fontSize: parsedSize,
      fontWeight: json['font_weight']?.toString() ??
          json['fontWeight']?.toString() ??
          'Regular',
      colorHex: json['color_hex']?.toString() ??
          json['colorHex']?.toString() ??
          '#1E293B',
    );
  }

  Map<String, dynamic> toJson() => {
        'role': role,
        'font_size': fontSize,
        'font_weight': fontWeight,
        'color_hex': colorHex,
      };
}

class UIComponentItem {
  final String name;
  final String type;
  final String description;

  const UIComponentItem({
    required this.name,
    required this.type,
    required this.description,
  });

  factory UIComponentItem.fromJson(Map<String, dynamic> json) {
    return UIComponentItem(
      name: json['name']?.toString() ?? 'Component',
      type: json['type']?.toString() ?? 'Widget',
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'description': description,
      };
}

class UIAnalysisModel {
  final String summary;
  final List<ColorItem> detectedColors;
  final List<TypographyItem> typography;
  final List<UIComponentItem> detectedComponents;
  final String layoutHierarchy;
  final String responsiveNotes;
  final String flutterCode;
  final Map<String, dynamic>? uiSpec;
  final DateTime createdAt;

  UIAnalysisModel({
    required this.summary,
    required this.detectedColors,
    required this.typography,
    required this.detectedComponents,
    required this.layoutHierarchy,
    required this.responsiveNotes,
    required this.flutterCode,
    this.uiSpec,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UIAnalysisModel.fromJson(Map<String, dynamic> json) {
    final rawColors = json['detected_colors'] ?? json['colors'];
    final colorsList = (rawColors is List)
        ? rawColors
            .whereType<Map<String, dynamic>>()
            .map((c) => ColorItem.fromJson(c))
            .toList()
        : <ColorItem>[];

    final rawTypo = json['typography'];
    final typoList = (rawTypo is List)
        ? rawTypo
            .whereType<Map<String, dynamic>>()
            .map((t) => TypographyItem.fromJson(t))
            .toList()
        : <TypographyItem>[];

    final rawComp = json['detected_components'] ?? json['components'];
    final compList = (rawComp is List)
        ? rawComp
            .whereType<Map<String, dynamic>>()
            .map((k) => UIComponentItem.fromJson(k))
            .toList()
        : <UIComponentItem>[];

    final rawUiSpec = json['ui_spec'] ?? json['uiSpec'];
    Map<String, dynamic>? parsedUiSpec;
    if (rawUiSpec is Map<String, dynamic>) {
      parsedUiSpec = rawUiSpec;
    }

    return UIAnalysisModel(
      summary: json['summary']?.toString() ?? 'UI Analysis Completed',
      detectedColors: colorsList,
      typography: typoList,
      detectedComponents: compList,
      layoutHierarchy: json['layout_hierarchy']?.toString() ??
          json['layoutHierarchy']?.toString() ??
          'Scaffold > Column',
      responsiveNotes: json['responsive_notes']?.toString() ??
          json['responsiveNotes']?.toString() ??
          'Responsive layout with clean widgets.',
      flutterCode: json['flutter_code']?.toString() ??
          json['flutterCode']?.toString() ??
          '// No code generated',
      uiSpec: parsedUiSpec,
    );
  }

  Map<String, dynamic> toJson() => {
        'summary': summary,
        'detected_colors': detectedColors.map((c) => c.toJson()).toList(),
        'typography': typography.map((t) => t.toJson()).toList(),
        'detected_components':
            detectedComponents.map((c) => c.toJson()).toList(),
        'layout_hierarchy': layoutHierarchy,
        'responsive_notes': responsiveNotes,
        'flutter_code': flutterCode,
        'ui_spec': uiSpec,
        'created_at': createdAt.toIso8601String(),
      };
}
