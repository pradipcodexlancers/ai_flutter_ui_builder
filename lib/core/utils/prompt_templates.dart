class PromptTemplates {
  PromptTemplates._();

  static String analyzeAndGenerateFlutterPrompt({String? customInstruction}) {
    final customSection = (customInstruction != null && customInstruction.trim().isNotEmpty)
        ? '\n\nUSER CUSTOM REQUIREMENTS / EDITS:\n$customInstruction\n'
        : '';

    return '''
You are an expert Flutter Architect and UI/UX Designer.
Analyze the provided UI screenshot and convert it into high quality, production-ready Flutter Dart code.
$customSection
Follow these strict instructions:
1. UI Analysis:
   - Identify all colors used in the UI with their exact hex values (#RRGGBB).
   - Identify typography (font sizes, weights, and text roles).
   - Identify all visible UI components (AppBar, Buttons, TextFields, Cards, Lists, Badges, Icons, BottomNav, etc.).
   - Identify layout structure (Row, Column, Stack, ListView, Grid, Padding, Spacing).

2. Flutter Code Generation:
   - Write clean, modern, responsive Flutter code.
   - Use standard Flutter Material 3 widgets (`Colors`, `Icons.*`, `TextTheme`, `ElevatedButton`, `TextField`, etc.).
   - Never import external packages (like cupertino_icons or third-party packages) except `package:flutter/material.dart`.
   - Ensure the widget is self-contained and runnable (e.g. `GeneratedScreen extends StatelessWidget` or `StatefulWidget`).
   - Use responsive widgets like `SafeArea`, `SingleChildScrollView`, `Expanded`, `Flexible`, `LayoutBuilder`, or `Wrap` where appropriate to prevent overflows.
   - Add clear comments explaining key layout sections.

3. Structured Output:
   Return ONLY a valid JSON object without surrounding conversational text. Do not wrap with other commentary.
   The JSON must follow this exact schema:
{
  "summary": "Short 1-2 sentence description of the UI screen",
  "detected_colors": [
    {
      "name": "Primary / Background / Surface / Accent / etc.",
      "hex": "#6200EE",
      "usage": "Used for main CTA button and title"
    }
  ],
  "typography": [
    {
      "role": "Header / Subtitle / Body / Caption",
      "font_size": 24.0,
      "font_weight": "Bold",
      "color_hex": "#1E293B"
    }
  ],
  "detected_components": [
    {
      "name": "Component Name (e.g., Search Bar)",
      "type": "TextField",
      "description": "Rounded search input with prefix search icon and filter trailing icon"
    }
  ],
  "layout_hierarchy": "Scaffold > SafeArea > SingleChildScrollView > Column > [AppBar, HeaderCard, ActionGrid, BottomButton]",
  "responsive_notes": "SingleChildScrollView with BouncingScrollPhysics ensures no overflow on smaller devices. Flexible spacing maintains proportions.",
  "flutter_code": "import 'package:flutter/material.dart';\\n\\nclass GeneratedScreen extends StatelessWidget { ... }",
  "ui_spec": {
    "type": "Scaffold",
    "backgroundColor": "#FFFFFF",
    "appBar": {
      "title": "Screen Title",
      "backgroundColor": "#6200EE",
      "foregroundColor": "#FFFFFF",
      "showBackButton": true
    },
    "body": {
      "type": "Column",
      "crossAxisAlignment": "stretch",
      "padding": 16.0,
      "children": [
        {
          "type": "Text",
          "text": "Header Text",
          "fontSize": 22.0,
          "fontWeight": "bold",
          "color": "#1E293B"
        },
        {
          "type": "Spacing",
          "height": 16.0
        },
        {
          "type": "TextField",
          "hintText": "Search...",
          "icon": "search"
        },
        {
          "type": "Spacing",
          "height": 20.0
        },
        {
          "type": "Button",
          "text": "Submit",
          "backgroundColor": "#6200EE",
          "textColor": "#FFFFFF"
        }
      ]
    }
  }
}

Ensure the `ui_spec` structure accurately mimics the screenshot components.
Supported ui_spec types: Scaffold, Column, Row, Container, Card, Text, Button, OutlinedButton, TextField, Spacing, Icon, Avatar, ImagePlaceholder, Badge, Switch, Divider.
Make sure the JSON is 100% syntactically valid JSON. Escaping inside strings (especially `flutter_code`) must be valid.
''';
  }

  static String regenerateWithFeedbackPrompt({
    required String previousCode,
    required String feedback,
  }) {
    return '''
You are an expert Flutter Architect.
Here is the existing Flutter Dart code:
```dart
$previousCode
```

The user requested the following updates/changes:
"$feedback"

Please update the Flutter Dart code and the UI specification according to this feedback.
Return ONLY a valid JSON object matching the same schema:
{
  "summary": "Updated screen summary describing applied modifications",
  "detected_colors": [...],
  "typography": [...],
  "detected_components": [...],
  "layout_hierarchy": "...",
  "responsive_notes": "...",
  "flutter_code": "...",
  "ui_spec": { ... }
}
Do not include any conversational filler. Only the JSON object.
''';
  }
}
